import { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';

export interface AppError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

export class CustomError extends Error implements AppError {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number = 500) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  error: AppError,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const statusCode = error.statusCode || 500;
  const message = error.message || 'Wewnętrzny błąd serwera';

  // Loguj błąd
  logger.error('API Error:', {
    error: error.stack,
    url: req.url,
    method: req.method,
    statusCode,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
  });

  // Różne odpowiedzi dla production vs development
  const isDevelopment = process.env.NODE_ENV === 'development';

  const errorResponse = {
    success: false,
    error: message,
    statusCode,
    ...(isDevelopment && { stack: error.stack }),
  };

  res.status(statusCode).json(errorResponse);
};

// Helper do tworzenia błędów 400
export const createBadRequestError = (message: string) => {
  return new CustomError(message, 400);
};

// Helper do tworzenia błędów 401
export const createUnauthorizedError = (message: string = 'Brak autoryzacji') => {
  return new CustomError(message, 401);
};

// Helper do tworzenia błędów 403
export const createForbiddenError = (message: string = 'Brak uprawnień') => {
  return new CustomError(message, 403);
};

// Helper do tworzenia błędów 404
export const createNotFoundError = (message: string = 'Nie znaleziono') => {
  return new CustomError(message, 404);
};

// Helper do tworzenia błędów 409
export const createConflictError = (message: string) => {
  return new CustomError(message, 409);
}; 