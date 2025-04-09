const express = require('express');
const router = express.Router();

const { Item, Cart } = require('../models');

const verifyToken = require('../middleware/auth');

// get items by category (item_id, item_name, rating, price all three, image_urls)
router.get('/items-by-category', verifyToken, async (req, res) => {
    const { category_id, request_quantity, batch_no, user_id } = req.body;
    const page = parseInt(batch_no) || 1;
    const limit = request_quantity ? parseInt(request_quantity) : 50; // Default to 10 if not provided
    const offset = (page - 1) * limit;

    try {
        const items = await Item.findAll({
            where: { category: category_id },
            limit,
            offset,
        });

        const items_in_cart = await Cart.findAll({
            where: { user_id },
            attributes: ['product_id', 'quantity'],
        });

        // code to add the quantity of items in cart to the items
        items.forEach(item => {
            const cartItem = items_in_cart.find(cartItem => cartItem.product_id === item.product_id);
            if (cartItem) {
                item.quantity = cartItem.quantity;
            } else {
                item.quantity = 0;
            }
        });

        res.json({
            page,
            category_id,
            count: items.length,
            items
        });

    } catch (err) {
        console.error('Error fetching items by category:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});




// get details of a particular item (all things for that item)
router.get('/item-details', verifyToken, async (req, res) => {
    const { product_id, user_id } = req.body;

    try {
        const item = await Item.findOne({
            where: { product_id }
        });

        const items_in_cart = await Cart.findAll({
            where: { user_id:  user_id, product_id: product_id },
            attributes: ['product_id', 'quantity'],
        });

        if (!item) {
            return res.status(404).json({ error: 'Item not found' });
        }

        // code to add the quantity of items in cart to the item
        if (items_in_cart.length > 0) {
            item.quantity = items_in_cart[0].quantity;
        } else {
            item.quantity = 0;
        }

        res.json(item);

    } catch (err) {
        console.error('Error fetching item details:', err);
        res.status(500).json({ error: 'Something went wrong', err: err });
    }
});



module.exports = router;