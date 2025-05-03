

const express = require('express');

const router = express.Router();

const verifyToken = require('../middleware/auth');

const { Orders, Cart } = require('../models');



// post request for placing order
router.post('/place-order', verifyToken, async (req, res) => {
    const { user_id, order_id, order_items } = req.body;

    try {
        // Assuming you have a function to place the order
        const order = await placeOrder(user_id, order_id, order_items);

        if (!order) {
            return res.status(500).json({ error: 'Failed to place order' });
        }

        res.json({ message: 'Order placed successfully', order });
    } catch (err) {
        console.error('Error placing order:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});






















module.exports = router;