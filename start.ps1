# start.ps1 - PowerShell script for MomFriend on Windows

param(
    [string]$Command = "help"
)

function Show-Help {
    Write-Host "MomFriend - Dostepne komendy:" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Setup:" -ForegroundColor Yellow
    Write-Host "  .\start.ps1 install     - Instaluje wszystkie zaleznosci"
    Write-Host "  .\start.ps1 doctor      - Sprawdza wymagania systemowe"
    Write-Host ""
    Write-Host "Development:" -ForegroundColor Yellow
    Write-Host "  .\start.ps1 start       - Uruchamia aplikacje"
    Write-Host "  .\start.ps1 flutter     - Uruchamia tylko Flutter app"
    Write-Host "  .\start.ps1 quick       - Szybki start (tylko skrypt)"
    Write-Host ""
    Write-Host "Docker:" -ForegroundColor Yellow
    Write-Host "  .\start.ps1 docker      - Uruchamia bazy danych w Docker"
    Write-Host ""
    Write-Host "Management:" -ForegroundColor Yellow
    Write-Host "  .\start.ps1 stop        - Zatrzymuje wszystkie serwisy"
    Write-Host "  .\start.ps1 restart     - Restart aplikacji"
    Write-Host "  .\start.ps1 clean       - Czysci dane i kontenery"
    Write-Host "  .\start.ps1 logs        - Pokazuje logi"
}

function Test-Requirements {
    Write-Host "Sprawdzanie wymagan systemowych..." -ForegroundColor Yellow
    
    # Docker
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion) {
            Write-Host "  OK Docker: $dockerVersion" -ForegroundColor Green
        } else {
            Write-Host "  BRAK Docker: Nie zainstalowany" -ForegroundColor Red
        }
    } catch {
        Write-Host "  BRAK Docker: Nie zainstalowany" -ForegroundColor Red
    }
    
    # Node.js
    try {
        $nodeVersion = node --version 2>$null
        if ($nodeVersion) {
            Write-Host "  OK Node.js: $nodeVersion" -ForegroundColor Green
        } else {
            Write-Host "  BRAK Node.js: Nie zainstalowany" -ForegroundColor Red
        }
    } catch {
        Write-Host "  BRAK Node.js: Nie zainstalowany" -ForegroundColor Red
    }
    
    # Flutter
    try {
        $flutterOutput = flutter --version 2>$null | Select-Object -First 1
        if ($flutterOutput) {
            Write-Host "  OK Flutter: $flutterOutput" -ForegroundColor Green
        } else {
            Write-Host "  BRAK Flutter: Nie zainstalowany" -ForegroundColor Red
        }
    } catch {
        Write-Host "  BRAK Flutter: Nie zainstalowany" -ForegroundColor Red
    }
}

function Start-Databases {
    Write-Host "Uruchamianie baz danych..." -ForegroundColor Yellow
    docker-compose -f docker-compose.local.yml up -d postgres redis
    Write-Host "Bazy danych uruchomione" -ForegroundColor Green
}

function Start-Backend {
    Write-Host "Uruchamianie backend..." -ForegroundColor Yellow
    
    if (!(Test-Path "backend")) {
        Write-Host "BLAD: Katalog backend nie istnieje!" -ForegroundColor Red
        return
    }
    
    Set-Location backend
    
    # Install dependencies if needed
    if (!(Test-Path "node_modules")) {
        Write-Host "Instaluje zaleznosci..." -ForegroundColor Yellow
        npm install
    }
    
    # Create .env if not exists
    if (!(Test-Path ".env")) {
        Write-Host "Tworze .env..." -ForegroundColor Yellow
        Copy-Item "env.example" ".env" -ErrorAction SilentlyContinue
        if (!(Test-Path ".env")) {
            Copy-Item "../local.env" ".env" -ErrorAction SilentlyContinue
        }
    }
    
    # Start backend
    Start-Process -FilePath "cmd" -ArgumentList "/c", "npm run dev" -WindowStyle Minimized
    
    Set-Location ..
    
    # Wait for backend
    Write-Host "Czekam na backend..." -ForegroundColor Yellow
    for ($i = 1; $i -le 30; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing -TimeoutSec 2 2>$null
            if ($response.StatusCode -eq 200) {
                Write-Host "Backend dziala na http://localhost:3000" -ForegroundColor Green
                return
            }
        } catch {
            Start-Sleep -Seconds 1
        }
    }
    Write-Host "BLAD: Backend nie uruchomil sie w czasie" -ForegroundColor Red
}

function Start-Flutter {
    Write-Host "Uruchamianie Flutter..." -ForegroundColor Yellow
    
    try {
        flutter --version 2>$null | Out-Null
        if (!(Test-Path "momfriend")) {
            Write-Host "BLAD: Katalog momfriend nie istnieje!" -ForegroundColor Red
            return
        }
        
        Set-Location momfriend
        
        if (!(Test-Path "pubspec.lock")) {
            Write-Host "Pobieranie zaleznosci..." -ForegroundColor Yellow
            flutter pub get
        }
        
        Write-Host "Uruchamianie aplikacji..." -ForegroundColor Yellow
        flutter run
        
        Set-Location ..
    } catch {
        Write-Host "BLAD: Flutter nie jest dostepny" -ForegroundColor Red
        Write-Host "Zainstaluj Flutter z: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
    }
}

function Stop-All {
    Write-Host "Zatrzymywanie serwisow..." -ForegroundColor Yellow
    
    # Stop processes
    Get-Process | Where-Object {$_.ProcessName -like "*node*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process | Where-Object {$_.ProcessName -like "*flutter*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Stop Docker
    docker-compose -f docker-compose.local.yml down 2>$null
    
    Write-Host "Wszystko zatrzymane" -ForegroundColor Green
}

# Main logic
switch ($Command.ToLower()) {
    "help" { Show-Help }
    "doctor" { Test-Requirements }
    "install" {
        Test-Requirements
        if (Test-Path "backend") {
            Set-Location backend
            npm install
            Set-Location ..
        }
        if (Test-Path "momfriend") {
            Set-Location momfriend
            flutter pub get
            Set-Location ..
        }
    }
    "docker" { Start-Databases }
    "start" {
        Start-Databases
        Start-Sleep -Seconds 5
        Start-Backend
    }
    "flutter" { Start-Flutter }
    "stop" { Stop-All }
    "restart" {
        Stop-All
        Start-Sleep -Seconds 3
        & $MyInvocation.MyCommand.Path start
    }
    "clean" {
        Stop-All
        docker-compose -f docker-compose.local.yml down -v 2>$null
        docker system prune -f 2>$null
    }
    "logs" {
        if (Test-Path "backend/logs/backend.log") {
            Get-Content "backend/logs/backend.log" -Tail 20 -Wait
        } else {
            Write-Host "BLAD: Brak logow backend" -ForegroundColor Red
        }
    }
    "quick" {
        Write-Host "MomFriend Quick Start" -ForegroundColor Blue
        if (Test-Path "start-local.bat") {
            & "./start-local.bat"
        } else {
            Write-Host "BLAD: start-local.bat nie istnieje" -ForegroundColor Red
        }
    }
    default {
        Write-Host "BLAD: Nieznana komenda: $Command" -ForegroundColor Red
        Show-Help
    }
} 