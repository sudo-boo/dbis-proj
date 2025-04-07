
const express = require('express');
const dotenv = require('dotenv');
const sequelize = require('./config/database');
const { Item, Item_Category, Vendor, Availability, User, Orders, Cart, Payments } = require('./models');

dotenv.config();
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || 'My Express App';

// Sync DB
(async () => {
    try {
        await sequelize.authenticate();
        console.log('Connected to DB');

        await Item_Category.sync({ force: true }); // Drop & recreate for now
        await Item.sync({ force: true });
        await Vendor.sync({ force: true });
        await Availability.sync({ force: true });
        await User.sync({ force: true });
        await Cart.sync({ force: true });
        await Payments.sync({ force: true });
        await Orders.sync({ force: true });

        console.log('Models synced');
    } catch (err) {
        console.error('DB error:', err);
    }
})();



app.get('/', (req, res) => {
    res.send(`Welcome to ${APP_NAME} running on port ${PORT}`);
});

app.listen(PORT, () => {
    console.log(`${APP_NAME} is running on http://localhost:${PORT}`);
});




// Routes
// app.post('/items', async (req, res) => {
//     try {
//         const item = await Item.create(req.body);
//         res.status(201).json(item);
//     } catch (err) {
//         res.status(400).json({ error: err.message });
//     }
// });

// app.listen(PORT, () => {
//     console.log('Server running');
// });
