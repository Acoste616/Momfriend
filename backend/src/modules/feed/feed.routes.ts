import { Router } from 'express';

const router = Router();

// GET /api/feed/posts
router.get('/posts', (req, res) => {
  res.json({
    success: true,
    message: 'MomBoard posts',
    data: [
      {
        id: 'post1',
        type: 'question',
        content: 'Która kaszka najlepsza dla 6-miesięcznego brzuszka?',
        author: 'Anna',
        hearts: 12,
        comments: 8,
      },
    ],
  });
});

export { router as feedRouter }; 