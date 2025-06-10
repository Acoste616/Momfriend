import { Router } from 'express';

const router = Router();

// POST /api/verification/start
router.post('/start', (req, res) => {
  res.json({
    success: true,
    message: 'Proces weryfikacji rozpoczęty',
    data: {
      verificationId: 'verify123',
      steps: ['liveness', 'id_check'],
    },
  });
});

// POST /api/verification/submit
router.post('/submit', (req, res) => {
  res.json({
    success: true,
    message: 'Dokumenty przesłane do weryfikacji',
    data: null,
  });
});

export { router as verificationRouter }; 