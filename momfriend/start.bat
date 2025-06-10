@echo off
echo 🚀 Uruchamiam MomFriend...

REM Sprawdź czy backend działa
echo 📡 Sprawdzam backend...
curl -s http://localhost:3000/health > nul
if %errorlevel% neq 0 (
    echo ❌ Backend nie działa! Uruchom najpierw backend.
    echo Otwórz nowy terminal i wykonaj:
    echo cd ../backend ^&^& npm run start:dev
    pause
    exit /b 1
)

echo ✅ Backend działa

REM Instaluj dependencies
echo 📦 Instaluję zależności...
flutter pub get

REM Uruchom aplikację
echo 🌐 Uruchamiam w przeglądarce...
flutter run -d chrome --web-port=5000

pause 