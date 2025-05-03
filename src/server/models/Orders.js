const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Orders = sequelize.define('Orders', {
    order_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'users',
            key: 'user_id'
        }
    },
    items: {
        type: DataTypes.JSON,
        allowNull: false
    },
    total_price: {
        type: DataTypes.FLOAT,
        allowNull: false,
        validate: {
            min: 0
        }
    },
    vendor_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'vendor',
            key: 'vendor_id'
        }
    },
    d_boy_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'deliveryBoy',
            key: 'd_boy_id'
        }
    },
    order_date: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    order_time: {
        type: DataTypes.TIME,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    delivery_date: {
        type: DataTypes.DATE,
        allowNull: true
    },
    eta: {
        type: DataTypes.TIME,
        allowNull: true
    },
    transaction_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'payments',
            key: 'payment_id'
        }
    },
    status: {
        type: DataTypes.ENUM('ordered', 'sent from warehouse', 'delivered'),
        allowNull: false,
        defaultValue: 'ordered'
    },
}, {
    tableName: 'orders',
    timestamps: false,
});


module.exports = Orders;
