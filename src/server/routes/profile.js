
const express = require('express');

const router = express.Router();

const dotenv = require('dotenv');

const { Users } = require('../models');

const bcrypt = require('bcrypt');

const saltRounds = 8;


// get request to check if user is already registered with this email
router.get('/check-email', async (req, res) => {
    const { email } = req.body;
    try {
        const user = await Users.findOne({ where: { email } });
        if (user) {
            return res.status(200).json({ message: 'User already registered' });
        }
        return res.status(404).json({ message: 'User not found' });
    } catch (error) {
        console.error('Error checking email:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/make-user', async (req, res) => {
    const { name, phone, email, latitude, longitude, address, password } = req.body;

    try {

        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Add user to database
        const user = await Users.create({
            name,
            phone,
            email,
            latitude,
            longitude,
            address,
            password: hashedPassword
        });
        console.log('User created:', user);

        return res.status(200).json({ message: 'User created successfully' });
    } catch (error) {
        console.error('Error updating profile:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
});




module.exports = router;