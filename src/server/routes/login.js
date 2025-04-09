const express = require('express');

const router = express.Router();

const dotenv = require('dotenv');
dotenv.config();

const bcrypt = require('bcrypt');


const { Users } = require('../models');


const jwt = require('jsonwebtoken');

function generateToken(user) {
    return jwt.sign(
      { id: user.user_id, username: user.name },
      process.env.JWT_SECRET || 'supersecretkey',
      { expiresIn: '1h' }
    );
  }


// post request to make an express session for the user for login
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        // Check if the user exists
        const user = await Users.findOne({ where: { email } });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Compare the provided password with the hashed password in the database
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        // Generate a token for the user
        const token = generateToken(user);
        return res.json({message: 'Login successful', token: token });

    } catch (error) {
        console.error('Error during login:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
});





module.exports = router;