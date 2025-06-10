@echo off
REM start-local.bat - Skrypt uruchamiający MomFriend na Windows
setlocal EnableDelayedExpansion

echo 🚀 MomFriend - Uruchamianie lokalnego środowiska...
echo ==================================================================

REM Kolory (będą działać w nowszych wersjach CMD)
set "GREEN=[32m"
set "RED=[31m" 
set "YELLOW=[33m"
set "BLUE=[34m"
set "NC=[0m"

echo 📋 Sprawdzanie wymagań systemowych...

REM Sprawdź Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker nie jest zainstalowany!
    echo Zainstaluj Docker Desktop z: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker nie jest uruchomiony!
    echo Uruchom Docker Desktop
    pause
    exit /b 1
)

REM Sprawdź Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js nie jest zainstalowany!
    echo Zainstaluj Node.js z: https://nodejs.org/
    pause
    exit /b 1
)

REM Sprawdź wersję Node.js
for /f "tokens=1 delims=v" %%a in ('node --version') do set NODE_VERSION=%%a
echo ✅ Node.js %NODE_VERSION% wykryty

REM Sprawdź npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm nie jest zainstalowany!
    pause
    exit /b 1
)

REM Sprawdź Flutter
set FLUTTER_AVAILABLE=false
flutter --version >nul 2>&1
if not errorlevel 1 (
    set FLUTTER_AVAILABLE=true
    echo ✅ Flutter dostępny
) else (
    echo ⚠️ Flutter nie jest zainstalowany w PATH
    echo    Możesz uruchomić backend bez Flutter
    echo    Aby zainstalować Flutter: https://docs.flutter.dev/get-started/install/windows
)

echo ✅ Sprawdzanie wymagań zakończone!
echo.

REM Sprawdź porty
echo 🔍 Sprawdzanie dostępności portów...
netstat -an | findstr ":3000 " >nul 2>&1
if not errorlevel 1 (
    echo ❌ Port 3000 jest już używany!
    echo Zatrzymaj aplikację używającą portu 3000
    pause
    exit /b 1
)

set POSTGRES_EXTERNAL=false
netstat -an | findstr ":5432 " >nul 2>&1
if not errorlevel 1 (
    echo ⚠️ Port 5432 (PostgreSQL) jest już używany
    echo    Używam istniejącej instancji PostgreSQL
    set POSTGRES_EXTERNAL=true
)

set REDIS_EXTERNAL=false
netstat -an | findstr ":6379 " >nul 2>&1
if not errorlevel 1 (
    echo ⚠️ Port 6379 (Redis) jest już używany
    echo    Używam istniejącej instancji Redis
    set REDIS_EXTERNAL=true
)

echo.

REM Uruchom PostgreSQL
if "%POSTGRES_EXTERNAL%"=="false" (
    echo 🗄️ Uruchamianie bazy danych PostgreSQL...
    docker run -d --name momfriend-db --rm -e POSTGRES_DB=momfriend -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres123 -p 5432:5432 postgis/postgis:14-3.2 >nul 2>&1
    
    echo ⏳ Czekam na uruchomienie PostgreSQL...
    timeout /t 5 /nobreak >nul
    
    REM Sprawdź czy PostgreSQL działa
    :wait_postgres
    docker exec momfriend-db pg_isready -U postgres >nul 2>&1
    if errorlevel 1 (
        timeout /t 2 /nobreak >nul
        goto wait_postgres
    )
    echo ✅ PostgreSQL działa
) else (
    echo ✅ Używam zewnętrznej instancji PostgreSQL
)

REM Uruchom Redis
if "%REDIS_EXTERNAL%"=="false" (
    echo 📦 Uruchamianie Redis...
    docker run -d --name momfriend-redis --rm -p 6379:6379 redis:7-alpine >nul 2>&1
    
    echo ⏳ Czekam na uruchomienie Redis...
    timeout /t 3 /nobreak >nul
    
    REM Sprawdź czy Redis działa
    :wait_redis
    docker exec momfriend-redis redis-cli ping >nul 2>&1
    if errorlevel 1 (
        timeout /t 1 /nobreak >nul
        goto wait_redis
    )
    echo ✅ Redis działa
) else (
    echo ✅ Używam zewnętrznej instancji Redis
)

echo.

REM Backend
echo 🖥️ Przygotowywanie backend...
if not exist "backend" (
    echo ❌ Katalog backend\ nie istnieje!
    pause
    exit /b 1
)

cd backend

REM Sprawdź czy node_modules istnieją
if not exist "node_modules" (
    echo 📦 Instaluję zależności npm...
    call npm install
    if errorlevel 1 (
        echo ❌ Błąd podczas instalacji npm!
        pause
        exit /b 1
    )
) else (
    echo ✅ Zależności npm już zainstalowane
)

REM Stwórz .env jeśli nie istnieje
if not exist ".env" (
    echo 📝 Tworzę plik .env...
    (
        echo NODE_ENV=development
        echo PORT=3000
        echo DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/momfriend
        echo REDIS_URL=redis://localhost:6379
        echo JWT_SECRET=mom-friend-local-secret-key-2025
        echo LOG_LEVEL=info
    ) > .env
)

REM Stwórz katalog logs
if not exist "logs" mkdir logs

echo 🚀 Uruchamianie backend serwera...
start /b "MomFriend Backend" cmd /c "npm run dev > logs\backend.log 2>&1"

REM Poczekaj na backend
echo ⏳ Czekam na uruchomienie backend...
:wait_backend
timeout /t 2 /nobreak >nul
curl -s http://localhost:3000/health >nul 2>&1
if errorlevel 1 goto wait_backend

echo ✅ Backend działa na http://localhost:3000

cd ..

echo.

REM Flutter
if "%FLUTTER_AVAILABLE%"=="true" (
    echo 📱 Przygotowywanie aplikacji Flutter...
    if not exist "momfriend" (
        echo ❌ Katalog momfriend\ nie istnieje!
        pause
        exit /b 1
    )
    
    cd momfriend
    
    REM Sprawdź czy pubspec.lock istnieje
    if not exist "pubspec.lock" (
        echo 📦 Pobieranie zależności Flutter...
        call flutter pub get
        if errorlevel 1 (
            echo ❌ Błąd podczas pobierania zależności Flutter!
            pause
            exit /b 1
        )
    ) else (
        echo ✅ Zależności Flutter już pobrane
    )
    
    echo 📱 Sprawdzam dostępne urządzenia...
    flutter devices >nul 2>&1
    if not errorlevel 1 (
        echo ✅ Znaleziono urządzenia Flutter
        echo 🚀 Uruchamianie aplikacji Flutter...
        echo    Wybierz urządzenie w następnym oknie...
        start "MomFriend Flutter" cmd /c "flutter run"
    ) else (
        echo ⚠️ Brak dostępnych urządzeń Flutter
        echo    Uruchom emulator Android/iOS lub użyj Chrome
        echo    Możesz uruchomić później: cd momfriend ^&^& flutter run
    )
    
    cd ..
) else (
    echo 📱 Flutter niedostępny - uruchom aplikację ręcznie gdy zainstalujesz Flutter
    echo    Instrukcja: cd momfriend ^&^& flutter run
)

echo.
echo ==================================================================
echo 🎉 MomFriend uruchomiony lokalnie!
echo.
echo 📊 Dostępne serwisy:
echo    • Backend API:    http://localhost:3000
echo    • Health Check:   http://localhost:3000/health
echo    • API Explorer:   http://localhost:3000/api
if "%POSTGRES_EXTERNAL%"=="false" (
    echo    • PostgreSQL:     localhost:5432 (user: postgres, password: postgres123^)
)
if "%REDIS_EXTERNAL%"=="false" (
    echo    • Redis:          localhost:6379
)
if "%FLUTTER_AVAILABLE%"=="true" (
    echo    • Flutter App:    Uruchomiona na urządzeniu/emulatorze
)
echo.
echo 🔧 Przydatne komendy:
echo    • Logi backend:   type backend\logs\backend.log
echo    • Restart:        restart-local.bat
echo    • Stop:           Ctrl+C w oknie terminala
echo.
echo ⏳ Aplikacja działa... Naciśnij Enter aby zatrzymać wszystko
pause >nul

REM Cleanup
echo 🧹 Zatrzymywanie aplikacji...
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im flutter.exe >nul 2>&1
docker stop momfriend-db momfriend-redis >nul 2>&1

echo ✅ Aplikacja zatrzymana
pause 