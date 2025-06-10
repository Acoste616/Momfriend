# 🚀 MomFriend - Quick Start Guide

**Uruchom całą aplikację MomFriend jedną komendą!**

---

## ⚡ Szybki start (1 komenda)

### 🖥️ Linux / macOS

```bash
# Pobierz uprawnienia i uruchom
chmod +x start-local.sh
./start-local.sh
```

### 🪟 Windows

```cmd
# Uruchom w Command Prompt lub PowerShell
start-local.bat
```

### 🐳 Docker (uniwersalne)

```bash
# Używając Makefile
make start

# Lub docker-compose
docker-compose -f docker-compose.local.yml up -d
```

---

## 🎯 Co się dzieje podczas uruchomienia?

1. **Sprawdzenie wymagań** - Docker, Node.js, Flutter
2. **Uruchomienie baz danych** - PostgreSQL + Redis w Docker
3. **Instalacja zależności** - npm install, flutter pub get
4. **Uruchomienie backend** - API serwer na porcie 3000
5. **Uruchomienie Flutter** - aplikacja mobilna

---

## 📊 Po uruchomieniu dostępne są:

| Serwis | URL | Opis |
|--------|-----|------|
| 🖥️ Backend API | `http://localhost:3000` | Główne API |
| ✅ Health Check | `http://localhost:3000/health` | Status API |
| 🔍 API Explorer | `http://localhost:3000/api` | Dokumentacja API |
| 🗄️ PostgreSQL | `localhost:5432` | Baza danych |
| 📦 Redis | `localhost:6379` | Cache |
| 📱 Flutter App | Emulator/urządzenie | Aplikacja mobilna |

**Dane logowania do bazy:**
- User: `postgres`
- Password: `postgres123`
- Database: `momfriend`

---

## 🔧 Przydatne komendy

### Makefile Commands
```bash
make help          # Pokaż wszystkie komendy
make install       # Zainstaluj zależności
make start         # Uruchom aplikację
make stop          # Zatrzymaj wszystko
make restart       # Restart aplikacji
make clean         # Wyczyść wszystko
make logs          # Pokaż logi
make flutter       # Uruchom tylko Flutter
make test          # Uruchom testy
```

### Docker Commands
```bash
# Bazy danych tylko
docker-compose -f docker-compose.local.yml up -d postgres redis

# Wszystko w Docker
docker-compose -f docker-compose.local.yml --profile full-docker up -d

# Zatrzymaj
docker-compose -f docker-compose.local.yml down

# Wyczyść volumes
docker-compose -f docker-compose.local.yml down -v
```

### Manual Commands
```bash
# Backend ręcznie
cd backend && npm run dev

# Flutter ręcznie
cd momfriend && flutter run

# Restart
./restart-local.sh     # Linux/Mac
restart-local.bat      # Windows
```

---

## 🛠️ Troubleshooting

### ❌ "Docker nie jest zainstalowany"
```bash
# Linux
sudo apt install docker.io docker-compose

# macOS
brew install docker docker-compose

# Windows
# Pobierz Docker Desktop z docker.com
```

### ❌ "Node.js nie jest zainstalowany"
```bash
# Linux/macOS
# Pobierz z nodejs.org lub użyj nvm

# Windows
# Pobierz z nodejs.org
```

### ❌ "Flutter nie jest zainstalowany"
```bash
# macOS
brew install --cask flutter

# Linux (snap)
sudo snap install flutter --classic

# Windows
# Pobierz z flutter.dev
```

### ❌ Port już używany
```bash
# Sprawdź co używa portu 3000
lsof -i :3000                    # Linux/macOS
netstat -ano | findstr :3000     # Windows

# Zatrzymaj wszystko
make stop
./restart-local.sh
```

### ❌ Backend nie startuje
```bash
# Sprawdź logi
tail -f backend/logs/backend.log

# Reinstalacja zależności
cd backend
rm -rf node_modules package-lock.json
npm install
```

### ❌ Flutter problemy
```bash
# Czyść cache Flutter
cd momfriend
flutter clean
flutter pub get

# Sprawdź urządzenia
flutter devices

# Uruchom w przeglądarce
flutter run -d chrome
```

---

## 🚀 Pierwsze kroki po uruchomieniu

1. **Sprawdź backend** - otwórz `http://localhost:3000/health`
2. **Test API** - `curl http://localhost:3000/api/matching/profiles`
3. **Sprawdź bazę** - połącz się do PostgreSQL na localhost:5432
4. **Uruchom Flutter** - jeśli nie uruchomił się automatycznie: `make flutter`
5. **Testuj swipe** - aplikacja pokazuje testowe profile mam

---

## 📱 Testowanie aplikacji

### Testowe profile
Aplikacja zawiera 5 realistycznych profili mam z dziećmi:

- **Ania** (32l) - mama Zuzi (2l), miłośniczka kawy i spacerów
- **Kasia** (28l) - mama Maksa (4l) i Oli (1l), organizuje playdates  
- **Magda** (35l) - mama Jasia (6l), aktywna mama z pasją do joggingu
- **Ola** (30l) - mama Emilki (3l), kreatywna mama uwielbiająca warsztaty
- **Beata** (27l) - mama Kubusia (5l), spokojna mama lubiąca książki

### Gesty swipe
- ➡️ **Swipe right** / tap 💚 = "Chętnie poznam!"
- ⬅️ **Swipe left** / tap 🌸 = "Może innym razem"  
- **Tap ⭐** = "Super mama!" (boost w algorytmie)

### Match probability
- Normal like: 30% szansy na match
- Super like: 70% szansy na match

---

## 🎯 Development Workflow

```bash
# Codzienne uruchomienie
make start

# Podczas kodowania (hot reload)
make dev

# Testowanie
make test

# Restart po zmianach
make restart

# Koniec dnia
make stop
```

---

## 🆘 Potrzebujesz pomocy?

1. **Sprawdź logi**: `make logs` lub `tail -f backend/logs/backend.log`
2. **Restart wszystkiego**: `make clean && make start`
3. **Sprawdź wymagania**: `make doctor`
4. **GitHub Issues**: Opisz problem z logami

---

## ✅ Status projektu

- ✅ **Backend**: W pełni funkcjonalny API z testowymi danymi
- ✅ **Database**: PostgreSQL z PostGIS gotowy do użycia
- ✅ **Flutter**: Kompletna aplikacja z systemem swipe
- ✅ **Docker**: Pełna konteneryzacja
- ✅ **Skrypty**: Automatyczne uruchomienie jedną komendą

**🎉 MomFriend MVP gotowy do testowania!**

Aplikacja powinna uruchomić się w ciągu 2-3 minut na każdym systemie z zainstalowanymi wymaganiami podstawowymi. 