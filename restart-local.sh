#!/bin/bash
# restart-local.sh - Restart MomFriend aplikacji

set -e

echo "🔄 MomFriend - Restart aplikacji"
echo "================================"

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🛑 Zatrzymywanie aplikacji...${NC}"

# Zatrzymaj procesy Node.js
echo -e "${YELLOW}   Zatrzymywanie backend...${NC}"
pkill -f "npm run dev" 2>/dev/null || true
pkill -f "node.*main.js" 2>/dev/null || true

# Zatrzymaj Flutter
echo -e "${YELLOW}   Zatrzymywanie Flutter...${NC}"
pkill -f "flutter run" 2>/dev/null || true

# Zatrzymaj Docker containers
echo -e "${YELLOW}   Zatrzymywanie Docker containers...${NC}"
docker stop momfriend-db momfriend-redis 2>/dev/null || true

# Krótka pauza
sleep 2

echo -e "${YELLOW}🧹 Czyszczenie cache...${NC}"

# Wyczyść cache Node.js jeśli potrzeba
if [ -d "backend" ]; then
    cd backend
    if [ -f "package-lock.json" ]; then
        echo -e "${YELLOW}   Sprawdzam zależności npm...${NC}"
        npm ci --silent >/dev/null 2>&1 || npm install --silent >/dev/null 2>&1
    fi
    cd ..
fi

# Wyczyść cache Flutter jeśli potrzeba
if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then
    cd momfriend
    echo -e "${YELLOW}   Sprawdzam zależności Flutter...${NC}"
    flutter pub get --suppress-analytics >/dev/null 2>&1 || true
    cd ..
fi

echo -e "${GREEN}✅ Czyszczenie zakończone${NC}"
echo ""

echo -e "${YELLOW}🚀 Uruchamianie ponownie...${NC}"

# Uruchom ponownie
if [ -x "./start-local.sh" ]; then
    echo -e "${GREEN}Używam start-local.sh${NC}"
    ./start-local.sh
elif [ -f "Makefile" ]; then
    echo -e "${GREEN}Używam Makefile${NC}"
    make start
elif [ -f "start.sh" ] && [ -x "start.sh" ]; then
    echo -e "${GREEN}Używam start.sh${NC}"
    ./start.sh
else
    echo -e "${RED}❌ Nie znalazłem skryptu startowego!${NC}"
    echo "Spróbuj uruchomić ręcznie:"
    echo "  ./start-local.sh"
    echo "  make start"
    echo "  ./start.sh"
    exit 1
fi 