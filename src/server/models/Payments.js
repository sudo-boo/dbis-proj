const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Payments = sequelize.define('Payments', {
    payment_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        unique: true,
        primaryKey: true,
        autoIncrement: true
    },
    transaction_type: {
        type: DataTypes.ENUM('UPI', 'COD'),
        allowNull: false
    },
    transaction_id: {
        type: DataTypes.STRING,
        allowNull: true
    },
    status: {
        type: DataTypes.ENUM('PENDING', 'SUCCESS', 'FAILED'),
        allowNull: false
    }
}, {
    tableName: 'payments',
    timestamps: false,
});


module.exports = Payments;
