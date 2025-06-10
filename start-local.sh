#!/bin/bash
# start-local.sh - Skrypt uruchamiający MomFriend lokalnie

set -e # Exit on error

# Kolory dla lepszej czytelności
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 MomFriend - Uruchamianie lokalnego środowiska...${NC}"
echo "=================================================================="

# Funkcja sprawdzająca czy komenda istnieje
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Funkcja sprawdzająca port
check_port() {
    lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1
}

# Cleanup handler
cleanup() {
    echo -e "\n${YELLOW}🧹 Zamykanie aplikacji...${NC}"
    
    # Kill background processes
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null || true
    fi
    
    # Stop Docker containers
    docker stop momfriend-db momfriend-redis 2>/dev/null || true
    
    echo -e "${GREEN}✅ Aplikacja zatrzymana${NC}"
    exit 0
}

trap cleanup EXIT INT TERM

echo -e "${YELLOW}📋 Sprawdzanie wymagań systemowych...${NC}"

# Sprawdź Docker
if ! command_exists docker; then
    echo -e "${RED}❌ Docker nie jest zainstalowany!${NC}"
    echo "Zainstaluj Docker z: https://www.docker.com/get-started"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker nie jest uruchomiony!${NC}"
    echo "Uruchom Docker Desktop lub Docker daemon"
    exit 1
fi

# Sprawdź Node.js
if ! command_exists node; then
    echo -e "${RED}❌ Node.js nie jest zainstalowany!${NC}"
    echo "Zainstaluj Node.js z: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2)
if [[ "$(printf '%s\n' "18.0.0" "$NODE_VERSION" | sort -V | head -n1)" != "18.0.0" ]]; then
    echo -e "${RED}❌ Node.js wersja $NODE_VERSION jest za stara! Wymagana >= 18.0.0${NC}"
    exit 1
fi

# Sprawdź npm
if ! command_exists npm; then
    echo -e "${RED}❌ npm nie jest zainstalowany!${NC}"
    exit 1
fi

# Sprawdź Flutter
FLUTTER_AVAILABLE=false
if command_exists flutter; then
    FLUTTER_AVAILABLE=true
    echo -e "${GREEN}✅ Flutter dostępny${NC}"
else
    echo -e "${YELLOW}⚠️  Flutter nie jest zainstalowany w PATH${NC}"
    echo -e "${YELLOW}   Sprawdzam czy można zainstalować automatycznie...${NC}"
    
    # Próba automatycznej instalacji Flutter
    if [[ "$OSTYPE" == "darwin"* ]] && command_exists brew; then
        echo -e "${YELLOW}🍺 Instaluję Flutter przez Homebrew...${NC}"
        brew install --cask flutter
        FLUTTER_AVAILABLE=true
    elif command_exists snap; then
        echo -e "${YELLOW}📦 Instaluję Flutter przez Snap...${NC}"
        sudo snap install flutter --classic
        FLUTTER_AVAILABLE=true
    else
        echo -e "${YELLOW}ℹ️  Możesz uruchomić backend bez Flutter${NC}"
        echo -e "${YELLOW}   Aby zainstalować Flutter: https://docs.flutter.dev/get-started/install${NC}"
    fi
fi

echo -e "${GREEN}✅ Sprawdzanie wymagań zakończone!${NC}"
echo ""

# Sprawdź konflikty portów
echo -e "${YELLOW}🔍 Sprawdzanie dostępności portów...${NC}"
if check_port 3000; then
    echo -e "${RED}❌ Port 3000 jest już używany!${NC}"
    echo "Zatrzymaj aplikację używającą portu 3000 lub zmień port w konfiguracji"
    exit 1
fi

if check_port 5432; then
    echo -e "${YELLOW}⚠️  Port 5432 (PostgreSQL) jest już używany${NC}"
    echo -e "${YELLOW}   Używam istniejącej instancji PostgreSQL${NC}"
    POSTGRES_EXTERNAL=true
else
    POSTGRES_EXTERNAL=false
fi

if check_port 6379; then
    echo -e "${YELLOW}⚠️  Port 6379 (Redis) jest już używany${NC}"
    echo -e "${YELLOW}   Używam istniejącej instancji Redis${NC}"
    REDIS_EXTERNAL=true
else
    REDIS_EXTERNAL=false
fi

echo ""

# Uruchom bazę danych PostgreSQL
if [ "$POSTGRES_EXTERNAL" = false ]; then
    echo -e "${YELLOW}🗄️  Uruchamianie bazy danych PostgreSQL...${NC}"
    docker run -d \
      --name momfriend-db \
      --rm \
      -e POSTGRES_DB=momfriend \
      -e POSTGRES_USER=postgres \
      -e POSTGRES_PASSWORD=postgres123 \
      -p 5432:5432 \
      postgis/postgis:14-3.2 >/dev/null 2>&1 || true
    
    echo -e "${YELLOW}⏳ Czekam na uruchomienie PostgreSQL...${NC}"
    for i in {1..30}; do
        if docker exec momfriend-db pg_isready -U postgres >/dev/null 2>&1; then
            echo -e "${GREEN}✅ PostgreSQL działa${NC}"
            break
        fi
        sleep 1
        if [ $i -eq 30 ]; then
            echo -e "${RED}❌ PostgreSQL nie uruchomił się w czasie${NC}"
            exit 1
        fi
    done
else
    echo -e "${GREEN}✅ Używam zewnętrznej instancji PostgreSQL${NC}"
fi

# Uruchom Redis
if [ "$REDIS_EXTERNAL" = false ]; then
    echo -e "${YELLOW}📦 Uruchamianie Redis...${NC}"
    docker run -d \
      --name momfriend-redis \
      --rm \
      -p 6379:6379 \
      redis:7-alpine >/dev/null 2>&1 || true
    
    echo -e "${YELLOW}⏳ Czekam na uruchomienie Redis...${NC}"
    for i in {1..15}; do
        if docker exec momfriend-redis redis-cli ping >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Redis działa${NC}"
            break
        fi
        sleep 1
        if [ $i -eq 15 ]; then
            echo -e "${RED}❌ Redis nie uruchomił się w czasie${NC}"
            exit 1
        fi
    done
else
    echo -e "${GREEN}✅ Używam zewnętrznej instancji Redis${NC}"
fi

echo ""

# Backend
echo -e "${YELLOW}🖥️  Przygotowywanie backend...${NC}"
if [ ! -d "backend" ]; then
    echo -e "${RED}❌ Katalog backend/ nie istnieje!${NC}"
    exit 1
fi

cd backend

# Sprawdź czy node_modules istnieją
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Instaluję zależności npm...${NC}"
    npm install
else
    echo -e "${GREEN}✅ Zależności npm już zainstalowane${NC}"
fi

# Stwórz .env jeśli nie istnieje
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📝 Tworzę plik .env...${NC}"
    cat > .env << EOF
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/momfriend
REDIS_URL=redis://localhost:6379
JWT_SECRET=mom-friend-local-secret-key-2025
LOG_LEVEL=info
EOF
fi

# Stwórz katalog logs jeśli nie istnieje
mkdir -p logs

echo -e "${YELLOW}🚀 Uruchamianie backend serwera...${NC}"
npm run dev > logs/backend.log 2>&1 &
BACKEND_PID=$!

# Poczekaj na backend
echo -e "${YELLOW}⏳ Czekam na uruchomienie backend...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:3000/health >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend działa na http://localhost:3000${NC}"
        break
    fi
    sleep 1
    if [ $i -eq 30 ]; then
        echo -e "${RED}❌ Backend nie uruchomił się w czasie${NC}"
        echo -e "${RED}   Sprawdź logi: tail -f backend/logs/backend.log${NC}"
        exit 1
    fi
done

cd ..

echo ""

# Flutter
if [ "$FLUTTER_AVAILABLE" = true ]; then
    echo -e "${YELLOW}📱 Przygotowywanie aplikacji Flutter...${NC}"
    if [ ! -d "momfriend" ]; then
        echo -e "${RED}❌ Katalog momfriend/ nie istnieje!${NC}"
        exit 1
    fi
    
    cd momfriend
    
    # Sprawdź czy pubspec.lock istnieje
    if [ ! -f "pubspec.lock" ]; then
        echo -e "${YELLOW}📦 Pobieranie zależności Flutter...${NC}"
        flutter pub get
    else
        echo -e "${GREEN}✅ Zależności Flutter już pobrane${NC}"
    fi
    
    # Sprawdź dostępne urządzenia
    echo -e "${YELLOW}📱 Sprawdzam dostępne urządzenia...${NC}"
    DEVICES=$(flutter devices --machine 2>/dev/null | jq -r '.[].id' 2>/dev/null || echo "")
    
    if [ -z "$DEVICES" ]; then
        echo -e "${YELLOW}⚠️  Brak dostępnych urządzeń Flutter${NC}"
        echo -e "${YELLOW}   Uruchom emulator Android/iOS lub użyj Chrome${NC}"
        echo -e "${YELLOW}   Możesz uruchomić później: cd momfriend && flutter run${NC}"
    else
        echo -e "${GREEN}✅ Znaleziono urządzenia Flutter${NC}"
        echo -e "${YELLOW}🚀 Uruchamianie aplikacji Flutter...${NC}"
        
        # Sprawdź czy Chrome jest dostępny dla web
        if echo "$DEVICES" | grep -q "chrome"; then
            echo -e "${BLUE}🌐 Uruchamianie w Chrome...${NC}"
            flutter run -d chrome --web-port=8080 &
        else
            echo -e "${BLUE}📱 Uruchamianie na pierwszym dostępnym urządzeniu...${NC}"
            flutter run &
        fi
    fi
    
    cd ..
else
    echo -e "${YELLOW}📱 Flutter niedostępny - uruchom aplikację ręcznie gdy zainstalujesz Flutter${NC}"
    echo -e "${YELLOW}   Instrukcja: cd momfriend && flutter run${NC}"
fi

echo ""
echo "=================================================================="
echo -e "${GREEN}🎉 MomFriend uruchomiony lokalnie!${NC}"
echo ""
echo -e "${BLUE}📊 Dostępne serwisy:${NC}"
echo -e "   • Backend API:    ${GREEN}http://localhost:3000${NC}"
echo -e "   • Health Check:   ${GREEN}http://localhost:3000/health${NC}"
echo -e "   • API Explorer:   ${GREEN}http://localhost:3000/api${NC}"
if [ "$POSTGRES_EXTERNAL" = false ]; then
    echo -e "   • PostgreSQL:     ${GREEN}localhost:5432${NC} (user: postgres, password: postgres123)"
fi
if [ "$REDIS_EXTERNAL" = false ]; then
    echo -e "   • Redis:          ${GREEN}localhost:6379${NC}"
fi
if [ "$FLUTTER_AVAILABLE" = true ]; then
    echo -e "   • Flutter App:    ${GREEN}Uruchomiona na urządzeniu/emulatorze${NC}"
fi
echo ""
echo -e "${BLUE}🔧 Przydatne komendy:${NC}"
echo -e "   • Logi backend:   ${YELLOW}tail -f backend/logs/backend.log${NC}"
echo -e "   • Restart:        ${YELLOW}./restart-local.sh${NC}"
echo -e "   • Stop:           ${YELLOW}Ctrl+C${NC}"
echo ""
echo -e "${YELLOW}⏳ Aplikacja działa... Naciśnij Ctrl+C aby zatrzymać${NC}"

# Trzymaj skrypt żywy
while true; do
    sleep 1
    # Sprawdź czy backend nadal działa
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        echo -e "${RED}❌ Backend się zatrzymał!${NC}"
        exit 1
    fi
done 