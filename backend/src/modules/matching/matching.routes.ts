import { Router } from 'express';

const router = Router();

// GET /api/matching/profiles
router.get('/profiles', (req, res) => {
  res.json({
    success: true,
    message: 'Profile do matchowania',
    data: [
      {
        id: 'profile1',
        name: 'Kasia',
        age: 29,
        bio: 'Mama Jasia (3l) i Mali (1l). Kocham wspólne gotowanie 📚',
        distance: 1.2,
        matchScore: 85,
        isVerified: true,
      },
    ],
  });
});

// POST /api/matching/swipe
router.post('/swipe', (req, res) => {
  res.json({
    success: true,
    message: 'Swipe zapisany',
    data: {
      isMatch: Math.random() > 0.7, // 30% szansy na match
    },
  });
});

export { router as matchingRouter }; 