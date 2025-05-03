const Availability = require('./Availability');
const Item = require('./Item');
const Item_Category = require('./Item_Category');
const Vendor = require('./Vendor');
const Users = require('./Users');
const Orders = require('./Orders');
const Cart = require('./Cart');
const Payments = require('./Payments');
const deliveryBoy = require('./DeliveryBoy');

// Define associations here

// THINGS IN ITEM
Item.belongsTo(Item_Category, {
    foreignKey: 'category',
    targetKey: 'category_id',
    as: 'item_category'
});

Item_Category.hasMany(Item, {
    foreignKey: 'category',
    sourceKey: 'category_id',
    as: 'item'
});


// THINGS IN AVAILABILITY
Availability.belongsTo(Vendor, {
    foreignKey: 'vendor_id',
    sourceKey: 'vendor_id',
    as: 'vendor'
});

Vendor.hasMany(Availability, {
    foreignKey: 'vendor_id',
    sourceKey: 'vendor_id',
    as: 'availability'
});


Availability.belongsTo(Item, {
    foreignKey: 'product_id',
    sourceKey: 'product_id',
    as: 'item'
});

Item.hasMany(Availability, {
    foreignKey: 'product_id',
    sourceKey: 'product_id',
    as: 'availability'
});



//THINGS IN CART
Cart.belongsTo(Users, {
    foreignKey: 'user_id',
    targetKey: 'user_id',
    as: 'user'
});

Users.hasMany(Cart, {
    foreignKey: 'user_id',
    sourceKey: 'user_id',
    as: 'cart'
});


Cart.belongsTo(Item, {
    foreignKey: 'product_id',
    targetKey: 'product_id',
    as: 'item'
});

Item.hasMany(Cart, {
    foreignKey: 'product_id',
    sourceKey: 'product_id',
    as: 'cart'
});



// THINGS IN ORDERS
Orders.belongsTo(Users, {
    foreignKey: 'user_id',
    targetKey: 'user_id',
    as: 'users'
});
Users.hasMany(Orders, {
    foreignKey: 'user_id',
    sourceKey: 'user_id',
    as: 'orders'
});


Orders.belongsTo(Payments, {
    foreignKey: 'payment_id',
    targetKey: 'payment_id',
    as: 'payments'
});

Payments.hasMany(Orders, {
    foreignKey: 'payment_id',
    sourceKey: 'payment_id',
    as: 'orders'
});

Orders.belongsTo(deliveryBoy, {
    foreignKey: 'd_boy_id',
    sourceKey: 'd_boy_id',
    as : 'deliveryBoy'
});

deliveryBoy.hasMany(Orders, {
    foreignKey: 'd_boy_id', 
    sourceKey: 'd_boy_id',
    as : 'orders' 
});

Orders.belongsTo(Vendor, {
    foreignKey: 'vendor_id',
    sourceKey: 'vendor_id',
    as : 'vendor'
});

Vendor.hasMany(Orders, {
    foreignKey: 'vendor_id', 
    sourceKey: 'vendor_id',
    as : 'vendor' 
});


module.exports = {
    Item,
    Item_Category,
    Vendor,
    Availability,
    Users,
    Orders,
    Cart,
    Payments,
    deliveryBoy
};