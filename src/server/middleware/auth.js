const jwt = require('jsonwebtoken');
require('dotenv').config();

function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;
  console.log('Authorization header:', authHeader);

  if (!authHeader) return res.status(401).json({ error: 'Missing token' });

  const token = authHeader.split(' ')[1];
  console.log('Extracted token:', token);

  jwt.verify(token, process.env.JWT_SECRET || 'supersecretkey', (err, decoded) => {
    if (err) {
      console.log('JWT Error:', err);
      return res.status(403).json({ error: 'Invalid token' });
    }

    req.user = decoded;
    next();
  });
}


module.exports = verifyToken;