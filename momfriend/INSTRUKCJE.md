# 🚀 MomFriend - Instrukcje uruchomienia

## Wymagania
- Flutter 3.19+ 
- Node.js 18+ (dla backendu)
- Chrome lub Edge (dla aplikacji web)

## Szybkie uruchomienie

### 1. Uruchom backend (w osobnym terminalu)
```bash
cd ../backend
npm install
npm run start:dev
```

### 2. Uruchom aplikację Flutter
```powershell
# W folderze momfriend/
.\run-app.ps1
```

Skrypt automatycznie:
- ✅ Sprawdzi połączenie z backendem
- 📦 Zainstaluje zależności Flutter
- 🌐 Uruchomi aplikację w przeglądarce (port 5000)

## Alternatywne uruchomienie

Jeśli skrypt nie działa, możesz uruchomić ręcznie:

```bash
# Instaluj zależności
flutter pub get

# Uruchom w Chrome
flutter run -d chrome --web-port=5000

# Lub w Edge
flutter run -d edge --web-port=5000
```

## Dostępne adresy
- 🌐 **Aplikacja**: http://localhost:5000
- 🔧 **Backend API**: http://localhost:3000
- 📊 **Health Check**: http://localhost:3000/health

## Rozwiązywanie problemów

### Backend nie odpowiada
```bash
# Sprawdź czy backend działa
curl http://localhost:3000/health
```

### Błędy kompilacji
```bash
# Wyczyść cache i przebuduj
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problemy z Firebase Auth Web
Jeśli występują błędy kompilacji związane z Firebase Auth Web, to są znane problemy z kompatybilnością. Aplikacja działa pomimo tych ostrzeżeń w trybie development.

## Funkcjonalności
- 💚 Swipowanie profili mam
- 🎯 System matchowania
- 📱 Responsywny design
- 🎨 Piękny UI/UX

## Struktura projektu
```
momfriend/
├── assets/           # Zasoby (fonts, images, animations)
├── lib/
│   ├── core/         # Konfiguracja, tematy, API
│   ├── features/     # Główne funkcjonalności
│   └── shared/       # Współdzielone komponenty
├── web/              # Konfiguracja web
└── run-app.ps1       # Skrypt uruchomieniowy
```

Miłego korzystania z MomFriend! 💚 