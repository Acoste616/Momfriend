@echo off
REM restart-local.bat - Restart MomFriend aplikacji na Windows

echo 🔄 MomFriend - Restart aplikacji
echo ================================

echo 🛑 Zatrzymywanie aplikacji...

REM Zatrzymaj procesy Node.js
echo    Zatrzymywanie backend...
taskkill /f /im node.exe >nul 2>&1

REM Zatrzymaj Flutter
echo    Zatrzymywanie Flutter...
taskkill /f /im flutter.exe >nul 2>&1

REM Zatrzymaj Docker containers
echo    Zatrzymywanie Docker containers...
docker stop momfriend-db momfriend-redis >nul 2>&1

REM Krótka pauza
timeout /t 3 /nobreak >nul

echo 🧹 Czyszczenie cache...

REM Sprawdź zależności npm
if exist "backend\" (
    cd backend
    if exist "package-lock.json" (
        echo    Sprawdzam zależności npm...
        call npm ci --silent >nul 2>&1 || call npm install --silent >nul 2>&1
    )
    cd ..
)

REM Sprawdź zależności Flutter
flutter --version >nul 2>&1
if not errorlevel 1 (
    if exist "momfriend\" (
        cd momfriend
        echo    Sprawdzam zależności Flutter...
        call flutter pub get >nul 2>&1
        cd ..
    )
)

echo ✅ Czyszczenie zakończone
echo.

echo 🚀 Uruchamianie ponownie...

REM Uruchom ponownie
if exist "start-local.bat" (
    echo Używam start-local.bat
    call start-local.bat
) else if exist "Makefile" (
    echo Używam Makefile
    make start
) else if exist "start.sh" (
    echo Używam start.sh
    bash start.sh
) else (
    echo ❌ Nie znalazłem skryptu startowego!
    echo Spróbuj uruchomić ręcznie:
    echo   start-local.bat
    echo   make start
    pause
    exit /b 1
) 