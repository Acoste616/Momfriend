# 🚀 Przewodnik instalacji MomFriend

## 📋 Wymagania systemowe

### Backend
- ✅ **Node.js** >= 18.0.0 (ZAINSTALOWANE)
- ✅ **npm** >= 8.0.0 (ZAINSTALOWANE)
- 🔧 **PostgreSQL** 14+ (z PostGIS dla geolokalizacji)
- 🔧 **Redis** 7+ (cache i sesje)

### Frontend (Flutter)
- ⚠️ **Flutter SDK** >= 3.10.0 (DO ZAINSTALOWANIA)
- ⚠️ **Dart SDK** (automatycznie z Flutter)
- 🔧 **Android Studio** / **Xcode** (dla emulatorów)
- 🔧 **Visual Studio Code** (rekomendowane IDE)

### Opcjonalne (Docker)
- 🔧 **Docker** + **Docker Compose**

---

## 🛠️ Instalacja krok po kroku

### 1. Backend (Node.js) ✅ GOTOWE

Backend jest już w pełni skonfigurowany i działa!

```bash
# Przejdź do katalogu backend
cd backend

# Zainstaluj zależności (już zrobione)
npm install

# Uruchom serwer development
npm run dev

# Serwer dostępny na: http://localhost:3000
```

**Status:** ✅ Backend działa idealnie!
- Health check: ✅ http://localhost:3000/health
- API endpoints: ✅ Wszystkie routy odpowiadają
- Logging: ✅ Winston logger skonfigurowany
- Security: ✅ Helmet, CORS, Rate limiting

### 2. Flutter SDK Installation

#### Windows (Twój system)

```powershell
# Opcja 1: Chocolatey (jeśli masz)
choco install flutter

# Opcja 2: Ręczna instalacja
# Pobierz Flutter SDK z: https://docs.flutter.dev/get-started/install/windows
# Rozpakuj do C:\flutter
# Dodaj C:\flutter\bin do PATH

# Sprawdź instalację
flutter doctor

# Zaakceptuj licencje Android
flutter doctor --android-licenses
```

#### macOS

```bash
# Homebrew
brew install --cask flutter

# Lub pobierz z: https://docs.flutter.dev/get-started/install/macos
```

#### Linux

```bash
# Snap
sudo snap install flutter --classic

# Lub pobierz z: https://docs.flutter.dev/get-started/install/linux
```

### 3. Android Studio / Emulator

```bash
# Pobierz Android Studio
# https://developer.android.com/studio

# Zainstaluj Android SDK i emulator
# Utwórz emulator urządzenia (np. Pixel 6)
```

### 4. Flutter App Setup

```bash
# Przejdź do katalogu Flutter
cd momfriend

# Pobierz zależności
flutter pub get

# Sprawdź czy wszystko OK
flutter doctor

# Uruchom aplikację (po instalacji emulatora)
flutter run
```

---

## 📱 Uruchomienie aplikacji

### Development workflow

1. **Uruchom backend:**
```bash
cd backend
npm run dev
```

2. **Uruchom Flutter (w nowym terminalu):**
```bash
cd momfriend
flutter run
```

3. **Otwórz w przeglądarce:**
- Backend API: http://localhost:3000
- Health check: http://localhost:3000/health
- API docs: http://localhost:3000/api (TODO)

---

## 🐳 Docker Setup (opcjonalne)

### Uruchomienie z Docker Compose

```bash
# Uruchom wszystkie serwisy
docker-compose up -d

# Serwisy dostępne na:
# - Backend API: http://localhost:3000
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379
# - Grafana: http://localhost:3001
# - Prometheus: http://localhost:9090
```

### Build własnego obrazu

```bash
# Build backend image
docker build -t momfriend-backend ./backend

# Run container
docker run -p 3000:3000 momfriend-backend
```

---

## 🧪 Testowanie

### Backend API Tests

```bash
cd backend

# Unit tests
npm test

# API integration tests
npm run test:integration

# Load testing
npm run test:load
```

### Flutter Tests

```bash
cd momfriend

# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

### Manual API Testing

```bash
# Health check
curl http://localhost:3000/health

# Auth endpoints
curl -X POST http://localhost:3000/api/auth/register
curl -X POST http://localhost:3000/api/auth/login

# Matching system
curl http://localhost:3000/api/matching/profiles
curl -X POST http://localhost:3000/api/matching/swipe \
  -H "Content-Type: application/json" \
  -d '{"profileId": "profile1", "action": "like"}'

# User profiles
curl http://localhost:3000/api/users/profile

# Chat system
curl http://localhost:3000/api/chat/conversations
```

---

## 🔧 Konfiguracja środowiska

### Backend Environment Variables

```bash
# Skopiuj przykładowy plik
cp backend/env.example backend/.env

# Edytuj backend/.env:
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://momfriend:password@localhost:5432/momfriend
JWT_SECRET=your-secret-key
```

### Flutter Configuration

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String API_BASE_URL = 'http://localhost:3000/api';
  static const String WS_URL = 'ws://localhost:3000';
}
```

---

## 🏆 Checklist instalacji

### Backend ✅
- [x] Node.js i npm zainstalowane
- [x] Zależności npm zainstalowane 
- [x] TypeScript kompiluje się bez błędów
- [x] Serwer startuje na porcie 3000
- [x] Health check endpoint odpowiada
- [x] Wszystkie API routes działają
- [x] Logger zapisuje do plików
- [x] Rate limiting skonfigurowany

### Flutter ⚠️
- [ ] Flutter SDK zainstalowany
- [ ] `flutter doctor` bez błędów
- [ ] Android Studio / emulator skonfigurowany
- [ ] `flutter pub get` wykonany
- [ ] Aplikacja uruchamia się bez błędów
- [ ] Swipe interface działa
- [ ] Połączenie z backend API
- [ ] BLoC state management działa

### Database (Opcjonalne)
- [ ] PostgreSQL zainstalowany
- [ ] Database `momfriend` utworzona
- [ ] PostGIS extension włączona
- [ ] Redis uruchomiony

### Production Ready
- [ ] Docker images budują się
- [ ] docker-compose.yml działa
- [ ] Environment variables ustawione
- [ ] SSL certificates (dla HTTPS)
- [ ] CI/CD pipeline skonfigurowany

---

## 🐛 Troubleshooting

### Flutter Issues

```bash
# Jeśli flutter nie jest rozpoznawany
# Dodaj do PATH: C:\flutter\bin (Windows)

# Jeśli doctor pokazuje błędy
flutter doctor --android-licenses
flutter doctor -v

# Cache issues
flutter clean
flutter pub get
```

### Backend Issues

```bash
# Port już używany
lsof -ti:3000 | xargs kill -9  # macOS/Linux
netstat -ano | findstr :3000   # Windows

# Missing dependencies
rm -rf node_modules package-lock.json
npm install

# TypeScript errors
npm run build
```

### Docker Issues

```bash
# Clean Docker
docker system prune -a

# Rebuild images
docker-compose down
docker-compose build --no-cache
docker-compose up
```

---

## 📞 Support

Jeśli masz problemy z instalacją:

1. Sprawdź sekcję troubleshooting powyżej
2. Uruchom `flutter doctor -v` i `npm run dev`
3. Sprawdź logi w `backend/logs/combined.log`
4. Otwórz issue w repozytorium GitHub

---

**Status projektu:** 🟡 Backend gotowy, Flutter wymaga Flutter SDK

✅ **Backend**: W pełni funkcjonalny API
⚠️ **Frontend**: Gotowy kod, wymaga Flutter SDK do uruchomienia 