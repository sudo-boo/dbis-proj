
const express = require('express');
const dotenv = require('dotenv');
const sequelize = require('./config/database');
const { Item, Item_Category, Vendor, Availability, Users, Orders, Cart, Payments, deliveryBoy } = require('./models');

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


        // Uncomment the following lines to force sync the models (this will drop existing tables)
        // await Item_Category.sync({ force: true });
        // await Item.sync({ force: true });
        // await Vendor.sync({ force: true });
        // await deliveryBoy.sync({ force: true });
        // await Availability.sync({ force: true });
        // await Users.sync({ force: true });
        // await Cart.sync({ force: true });
        // await Payments.sync({ force: true });
        // await Orders.sync({ force: true });
        
        // Sync models without dropping existing tables
        await Item_Category.sync();
        await Item.sync();
        await Vendor.sync();
        await deliveryBoy.sync();
        await Availability.sync();
        await Users.sync();
        await Cart.sync();
        await Payments.sync();
        await Orders.sync();

        console.log('Models synced');
    } catch (err) {
        console.error('DB error:', err);
    }
})();















// Middleware for authentication

const bodyParser = require('body-parser');
app.use(bodyParser.json());













// Routers
const orderRouter = require('./routes/order');
const itemsRouter = require('./routes/items');
const categoryRouter = require('./routes/category');
// const usersRouter = require('./routes/users');
// const homeRouter = require('./routes/home');
const cartRouter = require('./routes/cart');
const otpRouter = require('./routes/otp');
const profileRouter = require('./routes/profile');



app.use('/order', orderRouter);
app.use('/items', itemsRouter);
app.use('/category', categoryRouter);
// app.use('/users', usersRouter);
// app.use('/home', homeRouter);
app.use('/cart', cartRouter);
app.use('/otp', otpRouter);
app.use('/profile', profileRouter);














// Run the server
app.get('/', (req, res) => {
    res.send(`Welcome to ${APP_NAME} running on port ${PORT}`);
});

app.listen(PORT, () => {
    console.log(`${APP_NAME} is running on http://localhost:${PORT}`);
});