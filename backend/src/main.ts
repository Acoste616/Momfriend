import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';

import { logger } from './common/utils/logger';
import { errorHandler } from './common/middleware/error-handler';
import { authRouter } from './modules/auth/auth.routes';
import { usersRouter } from './modules/users/users.routes';
import { matchingRouter } from './modules/matching/matching.routes';
import { chatRouter } from './modules/chat/chat.routes';
import { feedRouter } from './modules/feed/feed.routes';
import { verificationRouter } from './modules/verification/verification.routes';

// Załaduj zmienne środowiskowe
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware bezpieczeństwa
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));

// CORS - tylko dla dozwolonych domen
const corsOptions = {
  origin: process.env.NODE_ENV === 'production' 
    ? ['https://momfriend.app', 'https://www.momfriend.app'] 
    : ['http://localhost:3000', 'http://localhost:8080'],
  credentials: true,
  optionsSuccessStatus: 200,
};
app.use(cors(corsOptions));

// Kompresja odpowiedzi
app.use(compression());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minut
  max: 100, // maksymalnie 100 requestów na IP w oknie czasowym
  message: {
    error: 'Za dużo requestów z tego IP, spróbuj ponownie za 15 minut.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// Bardziej restrykcyjny limit dla auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // maksymalnie 5 prób logowania na 15 minut
  message: {
    error: 'Za dużo prób logowania, spróbuj ponownie za 15 minut.',
  },
});

// Parsowanie JSON (z limitem rozmiaru)
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logowanie requestów
if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('combined', {
    stream: {
      write: (message: string) => logger.info(message.trim()),
    },
  }));
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
  });
});

// API Routes
app.use('/api/auth', authLimiter, authRouter);
app.use('/api/users', usersRouter);
app.use('/api/matching', matchingRouter);
app.use('/api/chat', chatRouter);
app.use('/api/feed', feedRouter);
app.use('/api/verification', verificationRouter);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Endpoint nie został znaleziony',
    path: req.originalUrl,
  });
});

// Global error handler (musi być na końcu)
app.use(errorHandler);

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  logger.info('SIGINT received, shutting down gracefully');
  process.exit(0);
});

// Uruchom serwer
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    logger.info(`🚀 MomFriend API uruchomione na porcie ${port}`);
    logger.info(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
    logger.info(`🌐 Health check: http://localhost:${port}/health`);
  });
}

export { app }; 