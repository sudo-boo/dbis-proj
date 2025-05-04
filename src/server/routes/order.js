

const express = require('express');

const router = express.Router();

const verifyToken = require('../middleware/auth');

const { Orders, Cart, Item, Users, deliveryBoy, Availability } = require('../models');
const getNearestVendor = require('../commons/get_nearest_vendor');
const getDistanceFromLatLonInKm = require('../commons/get_distance_in_km');
const { or } = require('sequelize');
const getNearestDeliveryBoy = require('../commons/get_nearest_delivery_boy');



// post request for placing order
router.post('/place-order', verifyToken, async (req, res) => {
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
        const userLatitude = parseFloat(user.longitude);
        const userLongitude = parseFloat(user.latitude);
        const vendor = (await getNearestVendor(userLongitude, userLatitude, 10))[0];
        if (!vendor) {
            return res.status(404).json({ message: 'No vendor found nearby' });
        }
        const vendorId = vendor.vendor_id;
        const vendorLatitude = vendor.getDataValue('latitude');
        const vendorLongitude = vendor.getDataValue('longitude');
        const delivery_boy = (await getNearestDeliveryBoy(userLongitude, userLatitude, 10))[0];
        if (!delivery_boy) {
            return res.status(400).json({error: "No delivery boy found nearby"});
        }
        const deliveryId = delivery_boy.getDataValue('d_boy_id');
        const deliveryLatitude = delivery_boy.getDataValue('latitude');
        const deliveryLongitude = delivery_boy.getDataValue('longitude');

        const now = new Date();
        console.log(now);
        console.log(now.getDate());

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

        // change the availability of delivery boy to be unavailable
        const d_boy = await deliveryBoy.findOne({ where: {d_boy_id: deliveryId}});
        d_boy.available = false;
        await d_boy.save();

        res.status(201).json({ message: 'Order placed successfully', order });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error placing order' });
    }
});


router.post('/update-eta', verifyToken, async (req, res) => {
    const { order_id } = req.body;
    try {
        const order = await Orders.findOne({ where: { order_id } });
        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }
        if (order.status !== 'out for delivery') {
            return res.status(200).json({ message: 'Order is not out for delivery', eta: order.eta });
        }
        const user = await Users.findOne({ where: { vendor_id: order.vendor_id } });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        const userLatitude = parseFloat(user.latitude);
        const userLongitude = parseFloat(user.longitude);
        const delivery_boy = await deliveryBoy.findOne({ where: { d_boy_id: order.d_boy_id}});
        const deliveryLatitude = delivery_boy.location.latitude;
        const deliveryLongitude = delivery_boy.location.longitude;

        const et = (getDistanceFromLatLonInKm(userLatitude, userLongitude, deliveryLatitude, deliveryLongitude))/30;
        const eta1 = `${Math.floor(et).toString().padStart(2, '0')}:${Math.floor((et - Math.floor(et)) * 60).toString().padStart(2, '0')}:00`;
        order.eta = eta1;
        await order.save();
        res.status(200).json({ message: 'ETA updated successfully', eta: order.eta });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error updating ETA' });
    }
});



// get request for fetching all orders for a user
router.post('/get-orders', verifyToken, async (req, res) => {
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

router.post('/get-active-orders', verifyToken, async (req, res) => {
    const { user_id } = req.body;

    try {
        const orders = await Orders.findAll({
            where: {
                user_id,
                status: {
                    [or]: ['ordered', 'prepared', 'out for delivery']
                }
            },
            attributes: ['order_id', 'items', 'total_price', 'order_date', 'order_time']
        });

        if (!orders || orders.length === 0) {
            return res.status(404).json({ message: 'No active orders found' });
        }

        res.status(200).json({ message: 'Active orders fetched successfully', orders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error fetching active orders' });
    }
});




// get request for fetching all orders for a vendor
router.post('/get-vendor-orders', verifyToken, async (req, res) => {
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



router.post('/vendor-change-status', verifyToken, async (req, res) => {
    const { order_id, status } = req.body;

    try {
        const order = await Orders.findOne({ where: { order_id } });

        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }

        order.status = status;
        await order.save();

        res.status(200).json({ message: 'Order status updated successfully', order });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error updating order status' });
    }
});


router.post('/delivery-boy-change-status', verifyToken, async (req, res) => {
    const { order_id, status } = req.body;

    try {
        const order = await Orders.findOne({ where: { order_id } });

        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }

        order.status = status;
        await order.save();

        res.status(200).json({ message: 'Order status updated successfully', order });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error updating order status' });
    }
});










module.exports = router;