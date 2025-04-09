//email verification

const express = require('express');
const nodemailer = require('nodemailer');

const router = express.Router();

const dotenv = require('dotenv');
dotenv.config();

// A simple in-memory store for OTPs
class OtpRegister {
    constructor() {
        this.data = {};
    }

    addOtp(email, otp) {
        this.cleanExpiredOtps();
        this.data[email] = { otp, expiry: Date.now() + 300 * 1000 }; // 5 minutes
    }

    getOtp(email) {
        this.cleanExpiredOtps();
        if (!this.data[email]) {
            return null;
        }
        return this.data[email];
    }

    verifyOtp(email, otp) {
        const otpData = this.getOtp(email);
        if (!otpData) {
            return false;
        }
        if (otpData.otp !== otp) {
            return false;
        }
        if (Date.now() > otpData.expiry) {
            delete this.data[email]; // Remove expired OTP
            return false;
        }
        return true;
    }

    deleteOtp(email) {
        this.cleanExpiredOtps();
        if (this.data[email]) {
            delete this.data[email];
        }
    }

    cleanExpiredOtps() {
        const now = Date.now();
        for (const email in this.data) {
            if (this.data[email].expiry < now) {
                delete this.data[email];
            }
        }
    }
}

// Generate random 6-digit OTP
const generateOTP = () => Math.floor(100000 + Math.random() * 900000);

const otpRegister = new OtpRegister();

// Route: /get-otp
router.post('/get-otp', async (req, res) => {
    const { email } = req.body;

    if (!email) {
        return res.status(400).json({ error: 'Email is required' });
    }

    try {

        // Generate OTP
        const otp = generateOTP();

        // Setup nodemailer transport
        const transporter = nodemailer.createTransport({
            service: 'gmail', // or any other email provider
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS
            }
        });

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Your OTP Code',
            text: `Your OTP is: ${otp}`
        };

        // Send email
        await transporter.sendMail(mailOptions);

        // Optionally: store OTP somewhere (DB, cache, etc.)
        // e.g., user.otp = otp; await user.save();

        otpRegister.addOtp(email, otp);



        console.log(otpRegister.data);
        res.status(200).json({ message: 'OTP sent successfully' });

    } catch (err) {
        console.error('Error sending OTP:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});


// Route: /verify-otp
router.post('/verify-otp', async (req, res) => {
    const { email, otp } = req.body;

    if (!email || !otp) {
        return res.status(400).json({ error: 'Email and OTP are required' });
    }

    try {
        // Verify OTP
        const isValid = otpRegister.verifyOtp(email, otp);

        if (isValid) {
            // OTP is valid, proceed with registration or login
            otpRegister.deleteOtp(email); // Remove OTP after successful verification
            res.status(200).json({ message: 'OTP verified successfully' });
        } else {
            res.status(400).json({ error: 'Invalid or expired OTP' });
        }
    } catch (err) {
        console.error('Error verifying OTP:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});




// Export the router
module.exports = router;