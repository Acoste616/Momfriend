# MomFriend MVP 💚

**"Tinder dla koleżanek" - Bezpieczna platforma łącząca mamy**

![MomFriend](https://img.shields.io/badge/MomFriend-MVP-FF6B6B)
![Flutter](https://img.shields.io/badge/Flutter-Frontend-02569B)
![Node.js](https://img.shields.io/badge/Node.js-Backend-339933)
![TypeScript](https://img.shields.io/badge/TypeScript-Language-3178C6)

## 🎯 O projekcie

MomFriend to aplikacja mobilna pomagająca mamom nawiązywać prawdziwe przyjaźnie, wymieniać się wsparciem i organizować wspólne aktywności z dziećmi. To bezpieczna przestrzeń dla mam, gdzie priorytetem jest budowanie społeczności opartej na zaufaniu.

### ✨ Kluczowe funkcje MVP

- 🔄 **System swipe** - poznawaj mamy z okolicy
- 💬 **Chat 1-on-1** - bezpieczne rozmowy z matchami
- 👶 **Profile z dziećmi** - wiek dzieci, zainteresowania
- 🛡️ **Weryfikacja tożsamości** - budowanie zaufania
- 📍 **Matching lokalizacyjny** - mamy w pobliżu (do 50km)
- 🎯 **Algorytm zgodności** - podobny wiek dzieci, zainteresowania
- 📱 **MomBoard** - społecznościowy feed z pytaniami i poradami

## 🏗️ Architektura

```
MomFriend/
├── momfriend/           # Flutter Mobile App
│   ├── lib/
│   │   ├── core/        # Tematy, utils, błędy
│   │   ├── features/    # Auth, Profile, Matching, Chat, Feed
│   │   ├── shared/      # Reużywalne komponenty
│   │   └── main.dart
│   └── pubspec.yaml
├── backend/             # Node.js + TypeScript API
│   ├── src/
│   │   ├── common/      # Middleware, utils
│   │   ├── modules/     # Auth, Users, Matching, Chat, Feed
│   │   └── main.ts
│   └── package.json
└── README.md
```

## 🚀 Instalacja i uruchomienie

### Wymagania

- **Flutter SDK** >= 3.10.0
- **Node.js** >= 18.0.0
- **npm** >= 8.0.0

### Backend (Node.js + TypeScript)

```bash
# Przejdź do katalogu backend
cd backend

# Zainstaluj zależności
npm install

# Stwórz katalog na logi (jeśli nie istnieje)
mkdir logs

# Uruchom serwer w trybie development
npm run dev

# Serwer będzie dostępny na http://localhost:3000
```

#### Testowanie backend API

```bash
# Health check
curl http://localhost:3000/health

# Test auth endpoints
curl -X POST http://localhost:3000/api/auth/register
curl -X POST http://localhost:3000/api/auth/login

# Test matching endpoints
curl http://localhost:3000/api/matching/profiles
```

### Frontend (Flutter)

```bash
# Przejdź do katalogu Flutter
cd momfriend

# Zainstaluj zależności Flutter
flutter pub get

# Uruchom aplikację na emulatorze/urządzeniu
flutter run

# Lub uruchom w trybie debug
flutter run --debug
```

## 🎨 Design System

### Paleta kolorów

```css
/* Ciepłe, przyjazne kolory */
--primary: #FF6B6B      /* Ciepły koral */
--secondary: #4ECDC4    /* Miętowy */
--accent: #FFE66D       /* Słoneczny żółty */
--background: #FFF5F5   /* Delikatny róż */
--success: #6BCF7F      /* Zielony */
--warning: #FFB84D      /* Pomarańczowy */
```

### Typografia

- **Główna**: Poppins (przyjazna, zaokrąglona)
- **Akcenty**: Pacifico (dla logo i tytułów)

### Komponenty

- `MomButton` - zaokrąglone przyciski z gradientami
- `ProfileCard` - karty profili do swipe
- `MatchDialog` - radosny dialog po matchu
- `MomChip` - tagi zainteresowań

## 📱 Funkcjonalności

### 1. Onboarding (< 4 minuty)

1. **WelcomeScreen** - ciepłe powitanie
2. **SignUpScreen** - rejestracja + social login
3. **ProfileSetupScreen** - podstawowe dane
4. **ChildrenSetupScreen** - dodaj dzieci
5. **InterestsSelectionScreen** - wybierz zainteresowania
6. **LocationPermissionScreen** - pozwolenie na lokalizację
7. **VerificationIntroScreen** - weryfikacja tożsamości

### 2. System matchowania

**Algorytm scoringu:**
- 30% odległość (max 50km)
- 30% wiek dzieci (±2 lata)
- 20% wspólne zainteresowania
- 10% dostępność czasowa
- 10% aktywność w aplikacji

**Gesty swipe:**
- ➡️ Swipe right / tap 💚 = "Chętnie poznam!"
- ⬅️ Swipe left / tap 🌸 = "Może innym razem"
- Tap ⭐ = "Super mama!" (boost w algorytmie)

### 3. Chat i komunikacja

- Wiadomości tekstowe z emoji
- Udostępnianie lokalizacji (place zabaw)
- Szybkie propozycje spotkań
- Icebreaker cards

### 4. MomBoard (Social Feed)

- Pytania od mam
- Ankiety społeczności
- Porady dnia
- Lokalne rekomendacje

## 🔐 Bezpieczeństwo

### Weryfikacja tożsamości
```typescript
interface VerificationFlow {
  step1: LivenessCheck;     // Selfie z AI detection
  step2: IDVerification;    // Skan dowodu (blur sensitive data)
  step3?: ChildVerification; // Opcjonalne - akt urodzenia
}
```

### System raportowania
- Automatyczna moderacja AI
- Filtrowanie toxic content
- Blokowanie użytkowników
- Escalation do human moderators

### Privacy First
- Minimalne zbieranie danych
- Dzieci = tylko inicjały i wiek
- Auto-blur twarzy dzieci na zdjęciach
- GDPR compliance

## 🧠 Psychologia i Engagement

### Daily Hooks
- **Check-in nastroju**: "Jak się dziś czujesz?"
- **Mama Tip Dnia**: Krótka porada
- **Nowe mamy**: Notyfikacje o nowych użytkowniczkach
- **Wspomnienia**: "Rok temu Twoje dziecko..."

### Gamifikacja (subtelna)
- Punkty za aktywność
- Badge "Złota Mama"
- Priorytet w wynikach
- Darmowy boost profilu

## 📊 Struktura API

### Authentication
```
POST /api/auth/register   # Rejestracja
POST /api/auth/login      # Logowanie
POST /api/auth/verify     # Weryfikacja email/SMS
POST /api/auth/logout     # Wylogowanie
```

### Users & Profiles
```
GET  /api/users/profile   # Pobranie profilu
PUT  /api/users/profile   # Aktualizacja profilu
POST /api/users/upload    # Upload zdjęć
```

### Matching
```
GET  /api/matching/profiles    # Potencjalne matches
POST /api/matching/swipe       # Zapisz swipe (like/pass)
POST /api/matching/superlike   # Super like
GET  /api/matching/matches     # Lista matchów
```

### Chat
```
GET  /api/chat/conversations   # Lista konwersacji
POST /api/chat/send           # Wyślij wiadomość
GET  /api/chat/:id/messages   # Historia wiadomości
```

### Feed (MomBoard)
```
GET  /api/feed/posts      # Posty na feed
POST /api/feed/post       # Stwórz post
POST /api/feed/react      # Reakcja (heart/comment)
```

### Verification
```
POST /api/verification/start     # Rozpocznij weryfikację
POST /api/verification/submit    # Prześlij dokumenty
GET  /api/verification/status    # Status weryfikacji
```

## 🧪 Testowanie

### Backend Tests
```bash
npm test                # Uruchom testy
npm run test:watch      # Testy w trybie watch
npm run test:cov        # Coverage raport
```

### Flutter Tests
```bash
flutter test                    # Unit tests
flutter test integration_test/  # Integration tests
flutter drive --target=test_driver/app.dart  # E2E tests
```

### Scenariusze testowe
1. **Happy Path**: Rejestracja → Weryfikacja → Match → Chat → Playdate
2. **Safety Test**: Raportowanie → Blokowanie → Moderacja
3. **Load Test**: 1000 równoczesnych swipe sessions

## 🚀 Deployment

### Docker
```bash
# Build backend image
docker build -t momfriend-backend ./backend

# Run with docker-compose
docker-compose up -d
```

### Environment Variables
```env
# Backend (.env)
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
```

## 📈 Metryki sukcesu MVP

- [ ] Użytkowniczka rejestruje się w <4 minuty
- [ ] Weryfikacja buduje zaufanie (>80% completion rate)
- [ ] Matching pokazuje relevantne profile (score >70%)
- [ ] Chat conversion rate >30% (match → message)
- [ ] Daily retention >40%
- [ ] Safety reports <1% użytkowników

## 🤝 Contributing

1. Fork projektu
2. Stwórz feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📝 Licencja

Ten projekt jest licencjonowany na licencji MIT - zobacz plik [LICENSE](LICENSE) dla szczegółów.

## 👥 Team

- **Frontend**: Flutter + Dart + BLoC pattern
- **Backend**: Node.js + TypeScript + Express
- **Database**: PostgreSQL + PostGIS (dla lokalizacji)
- **Storage**: AWS S3 (zdjęcia)
- **Analytics**: Custom events tracking

---

**MomFriend** - Bo każda mama zasługuje na wsparcie społeczności 💚

Stworzone z ❤️ dla mam, przez społeczność 