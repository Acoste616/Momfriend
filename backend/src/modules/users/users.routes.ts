import { Router } from 'express';

const router = Router();

// GET /api/users/profile
router.get('/profile', (req, res) => {
  res.json({
    success: true,
    message: 'Profil użytkownika',
    data: {
      id: 'user123',
      name: 'Anna',
      age: 32,
      bio: 'Mama Zuzi (2l). Uwielbiam kawę i spacery po parku 🌳',
      isVerified: true,
    },
  });
});

// PUT /api/users/profile
router.put('/profile', (req, res) => {
  res.json({
    success: true,
    message: 'Profil zaktualizowany',
    data: null,
  });
});

export { router as usersRouter }; 