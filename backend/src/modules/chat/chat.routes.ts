import { Router } from 'express';

const router = Router();

// GET /api/chat/conversations
router.get('/conversations', (req, res) => {
  res.json({
    success: true,
    message: 'Lista konwersacji',
    data: [],
  });
});

// POST /api/chat/send
router.post('/send', (req, res) => {
  res.json({
    success: true,
    message: 'Wiadomość wysłana',
    data: null,
  });
});

export { router as chatRouter }; 