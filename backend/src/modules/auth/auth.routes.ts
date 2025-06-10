import { Router } from 'express';

const router = Router();

// POST /api/auth/register
router.post('/register', (req, res) => {
  res.json({
    success: true,
    message: 'Rejestracja będzie dostępna wkrótce',
    data: null,
  });
});

// POST /api/auth/login
router.post('/login', (req, res) => {
  res.json({
    success: true,
    message: 'Logowanie będzie dostępne wkrótce',
    data: null,
  });
});

// POST /api/auth/logout
router.post('/logout', (req, res) => {
  res.json({
    success: true,
    message: 'Wylogowano pomyślnie',
    data: null,
  });
});

// POST /api/auth/verify
router.post('/verify', (req, res) => {
  res.json({
    success: true,
    message: 'Weryfikacja będzie dostępna wkrótce',
    data: null,
  });
});

export { router as authRouter }; 