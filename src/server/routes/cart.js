
const express = require('express');

const router = express.Router();

const { Op } = require('sequelize');

const sequelize = require('../config/database');

const { Item, Availability, Vendor, Users, Cart } = require('../models');

const verifyToken = require('../middleware/auth');












// get the items in cart along with their availability from the nearest vendor in 10km radius

const getDistanceFromLatLonInKm = require('../commons/get_distance_in_km');
const getNearestVendor = require('../commons/get_nearest_vendor');


router.get('/get-cart', verifyToken, async (req, res) => {
    const { user_id, latitude, longitude } = req.body;

    try {
        const user = await Users.findOne({
            where: { user_id }, // You should have `user_id` available in your request/session
            attributes: ['latitude', 'longitude']
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const userLatitude = parseFloat(latitude);
        const userLongitude = parseFloat(longitude);


        const nearestVendorIds = (getNearestVendor(userLatitude, userLongitude, 10, 10)).map(v => v.vendor_id);

        const cartItems = await Cart.findAll({
            where: { user_id },
            include: [
                {
                    model: Item,
                    as: 'item',
                    attributes: ['product_id', 'name', 'mrp', 'image_url'],
                    include: [
                        {
                            model: Availability,
                            as: 'availability',
                            where: {
                                vendor_id: nearestVendorIds
                            },
                            include: [
                                {
                                    model: Vendor,
                                    as: 'vendor',
                                    attributes: ['vendor_id', 'name', 'location'],
                                }
                            ]
                        }]
                },
            ]
        });

        if (!cartItems || cartItems.length === 0) {
            return res.status(404).json({ error: 'No items in cart' });
        }

        const filteredCartItems = cartItems.map(cartItem => {
            const availabilities = cartItem.item.availability || [];
        
            // Calculate distance for vendors with quantity > 0
            const nearbyVendors = availabilities
                .filter(a => a.quantity >= cartItem.quantity && a.vendor)
                .map(a => {
                    const loc = a.vendor.location;
                    const [latitude, longitude] = loc.coordinates;
                    const distance = getDistanceFromLatLonInKm(
                        userLatitude,
                        userLongitude,
                        latitude,
                        longitude
                    );
                    return { ...a, distance };
                })
            const filteredVendors = nearbyVendors
                .filter(a => a.distance <= 10); // within 10km
            
            
            // Find the nearest one (if any)
            const nearest = filteredVendors.sort((a, b) => a.distance - b.distance)[0];

        
            return {
                cart_id: cartItem.id,
                product_id: cartItem.product_id,
                quantity: cartItem.quantity,
                item: {
                    product_id: cartItem.item.product_id,
                    name: cartItem.item.name,
                    mrp: cartItem.item.mrp,
                    image_url: cartItem.item.image_url,
                    nearest_availability: nearest?.dataValues.quantity ?? 0
                }
            };
        });
        

        res.json({ message: 'Items in cart fetched', items: filteredCartItems });
    } catch (err) {
        console.error('Error fetching cart items:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});


// post request to add to cart
router.post('/add-to-cart', verifyToken, async (req, res) => {
    const { user_id, product_id, quantity } = req.body;

    try {
        const cartItem = await Cart.create({
            user_id,
            product_id,
            quantity
        });

        res.json({ message: 'Item added to cart' });
    } catch (err) {
        console.error('Error adding item to cart:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

// update request to update item in the cart
router.post('/update-cart', verifyToken, async (req, res) => {
    const { user_id, product_id, quantity } = req.body;

    try {
        const cartItem = await Cart.findOne({
            where: { user_id, product_id }
        });

        if (!cartItem) {
            return res.status(404).json({ error: 'Item not found in cart' });
        }
        if (quantity != 0)
        {
            cartItem.quantity = quantity;
            await cartItem.save();
        }
        else
        {
            await cartItem.destroy();
        }

        res.json({ message: 'Cart updated' });
    } catch (err) {
        console.error('Error updating cart:', err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});




module.exports = router;