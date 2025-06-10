#!/bin/bash
# start.sh - Prosty sposób uruchomienia MomFriend

set -e

echo "🚀 MomFriend - Quick Start"
echo "=========================="

# Sprawdź podstawowe wymagania
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "❌ docker-compose nie jest zainstalowany!"
    echo "Użyj: ./start-local.sh dla pełnej instalacji"
    exit 1
fi

# Uruchom bazy danych z docker-compose
echo "🗄️ Uruchamianie baz danych..."
docker-compose -f docker-compose.local.yml up -d postgres redis

# Poczekaj na bazy
echo "⏳ Czekam na uruchomienie baz danych..."
sleep 10

# Sprawdź czy backend ma zależności
if [ -d "backend" ] && [ ! -d "backend/node_modules" ]; then
    echo "📦 Instaluję zależności backend..."
    cd backend && npm install && cd ..
fi

# Uruchom backend lokalnie
if [ -d "backend" ]; then
    echo "🖥️ Uruchamianie backend..."
    cd backend
    npm run dev &
    BACKEND_PID=$!
    cd ..
    
    # Poczekaj na backend
    echo "⏳ Czekam na backend..."
    for i in {1..30}; do
        if curl -s http://localhost:3000/health >/dev/null 2>&1; then
            echo "✅ Backend działa na http://localhost:3000"
            break
        fi
        sleep 1
    done
fi

# Uruchom Flutter jeśli dostępny
if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then
    echo "📱 Uruchamianie Flutter..."
    cd momfriend
    
    # Sprawdź zależności
    if [ ! -f "pubspec.lock" ]; then
        flutter pub get
    fi
    
    # Uruchom aplikację
    echo "🚀 Uruchamianie aplikacji..."
    flutter run
    
    cd ..
else
    echo "⚠️ Flutter niedostępny lub brak katalogu momfriend/"
    echo "Backend działa na: http://localhost:3000"
fi

# Cleanup przy wyjściu
cleanup() {
    echo "🧹 Zatrzymywanie..."
    kill $BACKEND_PID 2>/dev/null || true
    docker-compose -f docker-compose.local.yml down
}
trap cleanup EXIT 