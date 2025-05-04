//email verification

const express = require('express');
const nodemailer = require('nodemailer');

const router = express.Router();

const dotenv = require('dotenv');
dotenv.config();


// get user profile
const { Users, Vendor, deliveryBoy } = require('../models');
const verifyToken = require('../middleware/auth');

router.post('/get-user-profile', verifyToken, async (req, res) => {
    const { email } = req.body;

    try {
        const user = await Users.findOne({
            where: { email },
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        return res.json(user);
    } catch (error) {
        console.error('Error fetching user profile:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// get vendor profile
router.post('/get-vendor-profile', verifyToken, async (req, res) => {
    const {email} = req.body;
    
    try {
        const user = await Vendor.findOne({
            where: {email: email}
        });

        if (!user) {
            return res.status(404).json({error: 'Vendor not found'});
        }

        return res.json(user);

    } catch (error) {
        console.error('Error fetching vendor profile:', error);
        res.status(500).json({error: 'Internal server error'})
    }
});

// get delivery boy profile

router.post('/get-delivery-boy-profile', verifyToken, async (req, res) => {
    const {email} = req.body;
    
    try {
        const user = await deliveryBoy.findOne({
            where: {email: email}
        });

        if (!user) {
            return res.status(404).json({error: 'Delivery boy not found'});
        }

        return res.json(user);

    } catch (error) {
        console.error('Error fetching vendor profile:', error);
        res.status(500).json({error: 'Internal server error'})
    }
});

// update user profile
router.post('/update-user-profile', verifyToken, async (req, res) => {
    const { email, name, phone_number, latitude, longitude, address } = req.body;

    try {
        const user = await Users.findOne({
            where: { email },
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }
        if (name)
        user.name = name;
        if (phone_number)
        user.phone = phone_number;
        if (latitude)
        user.latitude = latitude;
        if (longitude)
        user.longitude = longitude;
        if (address)
        user.address = address;

        await user.save();

        return res.json({ message: 'Profile updated successfully' });
    } catch (error) {
        console.error('Error updating user profile:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// update vendor profile
router.post('/update-vendor-profile', verifyToken, async (req, res) => {
    const { email, name, phone_number, address, availability } = req.body;

    try {
        const user = await Vendor.findOne({
            where: { email },
        });

        if (!user) {
            return res.status(404).json({ error: 'Vendor not found' });
        }
        if (name)
        user.name = name;
        if (phone_number)
        user.phone = phone_number;
        if (address)
        user.address = address;
        if (availability)
        user.availability = availability;

        await user.save();

        return res.json({ message: 'Profile updated successfully' });
    } catch (error) {
        console.error('Error updating vendor profile:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// update delivery boy profile
router.post('/update-delivery-boy-profile', verifyToken, async (req, res) => {
    const { email, name, phone_number, latitude, longitude, address, availability } = req.body;

    try {
        const user = await deliveryBoy.findOne({
            where: { email },
        });

        if (!user) {
            return res.status(404).json({ error: 'Delivery Boy not found' });
        }
        if (name)
        user.name = name;
        if (phone_number)
        user.phone = phone_number;
        if (address)
        user.address = address;
        if (availability)
        user.availability = availability;
        if (latitude)
        user.location = {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)] // [longitude, latitude]
        };

        await user.save();

        return res.json({ message: 'Profile updated successfully' });
    } catch (error) {
        console.error('Error updating vendor profile:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// Export the router
module.exports = router;
