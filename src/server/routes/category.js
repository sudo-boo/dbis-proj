

const express = require('express');

const router = express.Router();

const verifyToken = require('../middleware/auth');

const { Item_Category } = require('../models');



// get data for categories
router.get('/get-categories', verifyToken, async (req, res) => {
    try {
        const categories = await Item_Category.findAll({
            attributes: ['category_id', 'name', 'cat_image'],
        });

        if (!categories || categories.length === 0) {
            return res.status(404).json({ error: 'No categories found' });
        }

        res.json(categories);
    } catch (err) {
        console.error('Error fetching categories:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});






















module.exports = router;