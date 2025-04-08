const Availability = require('./Availability');
const Item = require('./Item');
const Item_Category = require('./Item_Category');
const Vendor = require('./Vendor');
const Users = require('./Users');
const Orders = require('./Orders');
const Cart = require('./Cart');
const Payments = require('./Payments');

// Define associations here

// THINGS IN ITEM
Item.belongsTo(Item_Category, {
    foreignKey: 'category',
    targetKey: 'category_id'
});

Item_Category.hasMany(Item, {
    foreignKey: 'category',
    sourceKey: 'category_id'
});


// THINGS IN AVAILABILITY
Availability.belongsTo(Vendor, {
    foreignKey: 'vendor_id',
    sourceKey: 'vendor_id'
});

Vendor.hasMany(Availability, {
    foreignKey: 'vendor_id',
    sourceKey: 'vendor_id'
});


Availability.belongsTo(Item, {
    foreignKey: 'product_id',
    sourceKey: 'product_id'
});

Item.hasMany(Availability, {
    foreignKey: 'product_id',
    sourceKey: 'product_id'
});



//THINGS IN CART
Cart.belongsTo(Users, {
    foreignKey: 'user_id',
    targetKey: 'user_id'
});

Users.hasMany(Cart, {
    foreignKey: 'user_id',
    sourceKey: 'user_id'
});


Cart.belongsTo(Item, {
    foreignKey: 'product_id',
    targetKey: 'product_id'
});

Item.hasMany(Cart, {
    foreignKey: 'product_id',
    sourceKey: 'product_id'
});



// THINGS IN ORDERS
Orders.belongsTo(Users, {
    foreignKey: 'user_id',
    targetKey: 'user_id'
});
Users.hasMany(Orders, {
    foreignKey: 'user_id',
    sourceKey: 'user_id'
});


Orders.belongsTo(Payments, {
    foreignKey: 'payment_id',
    targetKey: 'payment_id'
});

Payments.hasMany(Orders, {
    foreignKey: 'payment_id',
    sourceKey: 'payment_id'
});


module.exports = {
    Item,
    Item_Category,
    Vendor,
    Availability,
    Users,
    Orders,
    Cart,
    Payments
};