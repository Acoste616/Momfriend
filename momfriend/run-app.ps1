# run-app.ps1
Write-Host "Starting MomFriend..." -ForegroundColor Green

# Check if backend is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing
    Write-Host "Backend is running" -ForegroundColor Green
} catch {
    Write-Host "Backend is not running! Please start backend first." -ForegroundColor Red
    Write-Host "Open new terminal and run:" -ForegroundColor Yellow
    Write-Host "cd ../backend && npm run start:dev" -ForegroundColor Cyan
    exit 1
}

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
flutter pub get

# Run application
Write-Host "Starting in browser..." -ForegroundColor Green
flutter run -d chrome --web-port=5000

# If Chrome doesn't work, try Edge
if ($LASTEXITCODE -ne 0) {
    Write-Host "Trying Microsoft Edge..." -ForegroundColor Yellow
    flutter run -d edge --web-port=5000
} 