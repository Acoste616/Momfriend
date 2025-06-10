.PHONY: help install start stop clean restart dev full-docker logs test doctor

# Default target
help:
	@echo "🚀 MomFriend - Dostępne komendy:"
	@echo ""
	@echo "📦 Setup:"
	@echo "  make install     - Instaluje wszystkie zależności"
	@echo "  make doctor      - Sprawdza wymagania systemowe"
	@echo ""
	@echo "🚀 Development:"
	@echo "  make start       - Uruchamia aplikację (databases + backend)"
	@echo "  make dev         - Uruchamia z hot reload"
	@echo "  make flutter     - Uruchamia tylko Flutter app"
	@echo ""
	@echo "🐳 Docker:"
	@echo "  make full-docker - Uruchamia wszystko w Docker"
	@echo "  make db-only     - Uruchamia tylko bazy danych"
	@echo ""
	@echo "🔧 Management:"
	@echo "  make stop        - Zatrzymuje wszystkie serwisy"
	@echo "  make restart     - Restart aplikacji"
	@echo "  make clean       - Czyści dane i kontenery"
	@echo "  make logs        - Pokazuje logi"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test        - Uruchamia wszystkie testy"
	@echo "  make test-backend - Testy backend"
	@echo "  make test-flutter - Testy Flutter"

# Install all dependencies
install:
	@echo "📦 Instaluję zależności..."
	@if [ -d "backend" ]; then \
		echo "📦 Backend dependencies..."; \
		cd backend && npm install; \
	fi
	@if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then \
		echo "📦 Flutter dependencies..."; \
		cd momfriend && flutter pub get; \
	else \
		echo "⚠️  Flutter nie jest dostępny"; \
	fi
	@echo "✅ Instalacja zakończona!"

# System requirements check
doctor:
	@echo "🔍 Sprawdzanie wymagań systemowych..."
	@echo ""
	@echo "Docker:"
	@if command -v docker >/dev/null 2>&1; then \
		echo "  ✅ Docker: $$(docker --version)"; \
		if docker info >/dev/null 2>&1; then \
			echo "  ✅ Docker daemon: Running"; \
		else \
			echo "  ❌ Docker daemon: Not running"; \
		fi \
	else \
		echo "  ❌ Docker: Not installed"; \
	fi
	@echo ""
	@echo "Node.js:"
	@if command -v node >/dev/null 2>&1; then \
		echo "  ✅ Node.js: $$(node --version)"; \
	else \
		echo "  ❌ Node.js: Not installed"; \
	fi
	@if command -v npm >/dev/null 2>&1; then \
		echo "  ✅ npm: $$(npm --version)"; \
	else \
		echo "  ❌ npm: Not installed"; \
	fi
	@echo ""
	@echo "Flutter:"
	@if command -v flutter >/dev/null 2>&1; then \
		echo "  ✅ Flutter: $$(flutter --version | head -n1)"; \
	else \
		echo "  ❌ Flutter: Not installed"; \
	fi

# Start databases only
db-only:
	@echo "🗄️ Uruchamianie baz danych..."
	docker-compose -f docker-compose.local.yml up -d postgres redis
	@echo "✅ Bazy danych uruchomione:"
	@echo "  • PostgreSQL: localhost:5432"
	@echo "  • Redis: localhost:6379"

# Start application (recommended)
start: db-only
	@echo "⏳ Czekam na uruchomienie baz danych..."
	@sleep 5
	@if [ -d "backend" ]; then \
		echo "🖥️ Uruchamianie backend..."; \
		cd backend && \
		if [ ! -f ".env" ]; then \
			echo "📝 Tworzę .env..."; \
			cp env.example .env || true; \
		fi && \
		npm run dev & \
		echo $$! > ../backend.pid; \
		echo "⏳ Czekam na backend..."; \
		for i in $$(seq 1 30); do \
			if curl -s http://localhost:3000/health >/dev/null 2>&1; then \
				echo "✅ Backend działa na http://localhost:3000"; \
				break; \
			fi; \
			sleep 1; \
		done; \
	fi
	@echo ""
	@echo "🎉 MomFriend uruchomiony!"
	@echo "📊 Dostępne serwisy:"
	@echo "  • Backend API: http://localhost:3000"
	@echo "  • Health Check: http://localhost:3000/health"
	@echo ""
	@echo "📱 Aby uruchomić Flutter: make flutter"
	@echo "🛑 Aby zatrzymać: make stop"

# Development mode with hot reload
dev: start
	@echo "🔥 Uruchamianie w trybie development..."
	@if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then \
		echo "📱 Uruchamianie Flutter z hot reload..."; \
		cd momfriend && flutter run --hot; \
	else \
		echo "⚠️  Flutter niedostępny. Backend działa na http://localhost:3000"; \
		echo "Naciśnij Ctrl+C aby zatrzymać"; \
		tail -f backend/logs/backend.log 2>/dev/null || sleep infinity; \
	fi

# Run Flutter app only
flutter:
	@if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then \
		echo "📱 Uruchamianie Flutter app..."; \
		cd momfriend && \
		if [ ! -f "pubspec.lock" ]; then \
			echo "📦 Pobieranie zależności..."; \
			flutter pub get; \
		fi && \
		flutter run; \
	else \
		echo "❌ Flutter nie jest dostępny lub brak katalogu momfriend/"; \
		echo "Zainstaluj Flutter: https://docs.flutter.dev/get-started/install"; \
	fi

# Full Docker setup
full-docker:
	@echo "🐳 Uruchamianie wszystkiego w Docker..."
	docker-compose -f docker-compose.local.yml --profile full-docker up -d
	@echo "✅ Wszystkie serwisy uruchomione w Docker:"
	@echo "  • Backend API: http://localhost:3000"
	@echo "  • PostgreSQL: localhost:5432"
	@echo "  • Redis: localhost:6379"

# Stop all services
stop:
	@echo "🛑 Zatrzymywanie serwisów..."
	@if [ -f "backend.pid" ]; then \
		echo "🖥️ Zatrzymywanie backend..."; \
		kill $$(cat backend.pid) 2>/dev/null || true; \
		rm -f backend.pid; \
	fi
	@echo "🐳 Zatrzymywanie Docker containers..."
	docker-compose -f docker-compose.local.yml down
	@echo "✅ Wszystkie serwisy zatrzymane"

# Restart application
restart: stop start

# Clean everything
clean:
	@echo "🧹 Czyszczenie..."
	@make stop
	@echo "🗑️ Usuwanie Docker volumes..."
	docker-compose -f docker-compose.local.yml down -v
	@echo "🗑️ Czyszczenie Docker system..."
	docker system prune -f
	@if [ -d "backend/node_modules" ]; then \
		echo "🗑️ Usuwanie node_modules..."; \
		rm -rf backend/node_modules; \
	fi
	@if [ -d "momfriend/.dart_tool" ]; then \
		echo "🗑️ Czyszczenie Flutter cache..."; \
		cd momfriend && flutter clean; \
	fi
	@echo "✅ Czyszczenie zakończone"

# Show logs
logs:
	@echo "📋 Wybierz logi do wyświetlenia:"
	@echo "1) Backend logs"
	@echo "2) PostgreSQL logs"
	@echo "3) Redis logs"
	@echo "4) All Docker logs"
	@echo ""
	@echo "Backend logs:"
	@if [ -f "backend/logs/backend.log" ]; then \
		tail -f backend/logs/backend.log; \
	else \
		echo "❌ Brak logów backend"; \
	fi

# Run tests
test: test-backend test-flutter

test-backend:
	@if [ -d "backend" ]; then \
		echo "🧪 Uruchamianie testów backend..."; \
		cd backend && npm test; \
	else \
		echo "❌ Brak katalogu backend/"; \
	fi

test-flutter:
	@if command -v flutter >/dev/null 2>&1 && [ -d "momfriend" ]; then \
		echo "🧪 Uruchamianie testów Flutter..."; \
		cd momfriend && flutter test; \
	else \
		echo "❌ Flutter niedostępny lub brak katalogu momfriend/"; \
	fi

# Quick commands
quick-start:
	@echo "⚡ Quick Start - Najprostszy sposób uruchomienia"
	@if [ -x "./start-local.sh" ]; then \
		./start-local.sh; \
	else \
		make start; \
	fi 