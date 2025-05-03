

const express = require('express');

const router = express.Router();

const verifyToken = require('../middleware/auth');

const { Orders, Cart, Item, Users } = require('../models');
const getNearestVendor = require('../commons/get_nearest_vendor');
const getDistanceFromLatLonInKm = require('../commons/get_distance_in_km');
const { or } = require('sequelize');



// post request for placing order
router.post('/placeOrder', verifyToken, async (req, res) => {
    const { user_id} = req.body;

    try {

        // Check if the user exists
        const user = await Users.findOne({ where: { user_id } });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        // Get the cart items for the user
        const cartItems = await Cart.findAll({
            where: { user_id },
            attributes: ['product_id', 'quantity']
        });
        if (cartItems.length === 0) {
            return res.status(400).json({ message: 'Cart is empty' });
        }
        // Calculate the total price and prepare the items array
        let total_price = 0;
        const items = [];
        for (const cartItem of cartItems) {
            const item = await Item.findOne({ where: { product_id: cartItem.product_id } });
            if (!item) {
                return res.status(404).json({ message: `Item with ID ${cartItem.product_id} not found` });
            }
            const itemTotalPrice = item.mrp * cartItem.quantity;
            total_price += itemTotalPrice;
            items.push({
                product_id: item.product_id,
                quantity: cartItem.quantity,
                price: item.mrp
            });
        }

        // Get nearest vendor to the user
        const userLatitude = parseFloat(user.latitude);
        const userLongitude = parseFloat(user.longitude);
        const vendor = (await getNearestVendor(userLatitude, userLongitude, 10))[0];
        if (!vendor) {
            return res.status(404).json({ message: 'No vendor found nearby' });
        }
        const vendorId = vendor.vendor_id;
        const vendorLocation = vendor.location;
        const vendorLatitude = vendorLocation.latitude;
        const vendorLongitude = vendorLocation.longitude;
        const delivery_boy = (await getNearestDeliveryBoy(userLatitude, userLongitude, 10))[0];
        const deliveryId = delivery_boy.d_boy_id;
        const deliveryLatitude = delivery_boy.location.latitude;
        const deliveryLongitude = delivery_boy.location.longitude;

        const now = new Date();

        const minutes1 = now.getMinutes().toString().padStart(2, '0');
        const seconds1 = now.getSeconds().toString().padStart(2, '0');
        const hours1 = now.getHours().toString().padStart(2, '0');

        const currentTime = `${hours1}:${minutes1}:${seconds1}`;
        const et = (getDistanceFromLatLonInKm(userLatitude, userLongitude, vendorLatitude, vendorLongitude) + getDistanceFromLatLonInKm(vendorLatitude, vendorLongitude, deliveryLatitude, deliveryLongitude))/30;
        const eta1 = `${Math.floor(et).toString().padStart(2, '0')}:${Math.floor((et - Math.floor(et)) * 60).toString().padStart(2, '0')}:00`;
        // Create the order
        const order = await Orders.create({
            user_id: user_id,
            items: JSON.stringify(items),
            total_price: total_price,
            vendor_id: vendorId,
            d_boy_id: deliveryId,
            order_date: now.getDate(),
            order_time: currentTime,
            delivery_date: null,
            eta: eta1,
            transaction_id: null,
            status: 'ordered'
        });

        // Clear the cart after placing the order
        await Cart.destroy({ where: { user_id } });

        // remove the items from the availability table
        for (const cartItem of cartItems) {
            const item = await Item.findOne({ where: { product_id: cartItem.product_id } });
            if (!item) {
                return res.status(404).json({ message: `Item with ID ${cartItem.product_id} not found` });
            }
            const availability = await Availability.findOne({
                where: {
                    vendor_id: vendorId,
                    product_id: item.product_id
                }
            });
            if (availability) {
                if (availability.quantity > cartItem.quantity) {
                availability.quantity -= cartItem.quantity;
                await availability.save();
                }
                else
                {
                    await Availability.destroy({
                        where: {
                            vendor_id: vendorId,
                            product_id: item.product_id
                        }
                    });
                }
            }
        }

        res.status(201).json({ message: 'Order placed successfully', order });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error placing order' });
    }
});


// get request for fetching all orders
router.post('/getOrders', verifyToken, async (req, res) => {
    const { user_id } = req.body;

    try {
        const orders = await Orders.findAll({
            where: { user_id },
            attributes: ['order_id', 'items', 'total_price', 'order_date', 'order_time']
        });

        if (!orders || orders.length === 0) {
            return res.status(404).json({ message: 'No orders found' });
        }

        res.status(200).json({ message: 'Orders fetched successfully', orders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error fetching orders' });
    }
});





// get request for fetching all orders for a vendor
router.post('/getVendorOrders', verifyToken, async (req, res) => {
    const { vendor_id } = req.body;

    try {
        const orders = await Orders.findAll({
            where: { vendor_id },
            attributes: ['order_id', 'items', 'total_price', 'order_date', 'order_time']
        });

        if (!orders || orders.length === 0) {
            return res.status(404).json({ message: 'No orders found' });
        }

        res.status(200).json({ message: 'Orders fetched successfully', orders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error fetching orders' });
    }
});














module.exports = router;