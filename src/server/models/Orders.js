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
            model: 'user',
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
        allowNull: false,
        references: {
            model: 'payments',
            key: 'payment_id'
        }
    }
}, {
    tableName: 'orders',
    timestamps: false,
});


module.exports = Orders;
