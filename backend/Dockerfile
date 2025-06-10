# Multi-stage build dla optymalizacji rozmiaru obrazu
FROM node:18-alpine AS builder

# Metadata
LABEL maintainer="MomFriend Team"
LABEL description="MomFriend Backend API"
LABEL version="1.0.0"

# Stwórz katalog aplikacji
WORKDIR /app

# Skopiuj pliki dependency
COPY package*.json ./
COPY tsconfig.json ./

# Zainstaluj zależności (tylko production w końcowej fazie)
RUN npm ci --only=production && npm cache clean --force

# Skopiuj kod źródłowy
COPY src/ ./src/

# Zbuduj aplikację TypeScript
RUN npm run build

# === PRODUCTION STAGE ===
FROM node:18-alpine AS production

# Zainstaluj dumb-init dla proper signal handling
RUN apk add --no-cache dumb-init

# Stwórz non-root user dla bezpieczeństwa
RUN addgroup -g 1001 -S nodejs && \
    adduser -S momfriend -u 1001

# Stwórz katalog aplikacji
WORKDIR /app

# Skopiuj zależności z buildera
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Stwórz katalog na logi
RUN mkdir -p logs && chown -R momfriend:nodejs logs

# Przełącz na non-root user
USER momfriend

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "http.get('http://localhost:3000/health', (res) => process.exit(res.statusCode === 200 ? 0 : 1))"

# Uruchom aplikację z dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"] 