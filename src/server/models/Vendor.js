const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Vendor = sequelize.define('Vendor', {
    vendor_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: true
    },
    location: {
        type: DataTypes.GEOGRAPHY('POINT', 4326),
        allowNull: false
    },
    address: {
        type: DataTypes.STRING,
        allowNull: true
    },
    phone: {
        type: DataTypes.STRING,
        allowNull: true
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            isEmail: true
        }
    },
    opening_hours: {
        type: DataTypes.JSON,
        allowNull: true
    },
    available: {
        type: DataTypes.BOOLEAN,
        allowNull: true
    },
}, {
    tableName: 'vendor',
    timestamps: false
});


module.exports = Vendor;
