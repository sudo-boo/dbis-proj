const express = require('express');
const router = express.Router();

const { Item, Cart, Vendor, Availability, Users } = require('../models');

const verifyToken = require('../middleware/auth');




// get items by category

// const getDistanceFromLatLonInKm = require('../commons/get_distance_in_km');
const getNearestVendor = require('../commons/get_nearest_vendor');

router.post('/items-by-category', verifyToken, async (req, res) => {
    const { category_id, request_quantity, batch_no, user_id } = req.body;
    console.log(category_id, request_quantity, batch_no, user_id);
    const page = parseInt(batch_no) || 1;
    const limit = request_quantity ? parseInt(request_quantity) : 50; // Default to 10 if not provided
    const offset = (page - 1) * limit;

    try {
        const items = await Item.findAll({
            where: { category: parseInt(category_id) },
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


        // fetch the nearest vendor to the user location whose distance must be lesser than maxDistance
        const user = await Users.findOne({
            where: { user_id },
            attributes: ['latitude', 'longitude'],
        });
        const userLatitude = user.latitude;
        const userLongitude = user.longitude;
        const maxDistance = 10; // 10 km

        const nearestVendor = (await getNearestVendor(userLatitude, userLongitude, maxDistance))[0];
        if (!nearestVendor) {
            return res.status(404).json({ error: 'No vendors found nearby' });
        }

        // to each of the item, append the stock available in availability table from the nearest vendor found
        const availability = await Availability.findAll({
            where: { vendor_id: nearestVendor.vendor_id },
            attributes: ['product_id', 'quantity'],
        });
        items.forEach(item => {
            const availabilityItem = availability.find(avail => avail.product_id === item.product_id);
            if (availabilityItem) {
                item.dataValues.stock_available = availabilityItem.quantity;
            } else {
                item.dataValues.stock_available = 0;
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



router.post('/items-by-category-vendor', verifyToken, async (req, res) => {
    const { category_id, request_quantity, batch_no, vendor_id } = req.body;
    console.log(category_id, request_quantity, batch_no, user_id);
    const page = parseInt(batch_no) || 1;
    const limit = request_quantity ? parseInt(request_quantity) : 50; // Default to 10 if not provided
    const offset = (page - 1) * limit;

    try {
        const items = await Item.findAll({
            where: { category: parseInt(category_id) },
            limit,
            offset,
        });

        // code to add the quantity of items in cart to the items
        items.forEach(item => {
                item.quantity = 0;
        });

        // to each of the item, append the stock available in availability table from the nearest vendor found
        const availability = await Availability.findAll({
            where: { vendor_id: vendor_id },
            attributes: ['product_id', 'quantity'],
        });
        items.forEach(item => {
            const availabilityItem = availability.find(avail => avail.product_id === item.product_id);
            if (availabilityItem) {
                item.dataValues.stock_available = availabilityItem.quantity;
            } else {
                item.dataValues.stock_available = 0;
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
router.post('/item-details', verifyToken, async (req, res) => {
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


// update items 
router.post('/update-items', verifyToken, async (req, res) => {
    const { vendor_id, product_id, quantity } = req.body;
    try {
        const item = await Availability.findOne({
            where: { product_id, vendor_id }
        });

        if (!item) {
            return res.status(404).json({ error: 'Item not found' });
        }

        item.quantity += quantity;
        await item.save();

        res.json({ message: 'Item updated successfully' });

    } catch (err) {
        console.error('Error updating item:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});


module.exports = router;