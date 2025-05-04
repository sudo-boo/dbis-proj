const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const deliveryBoy = sequelize.define('delivery_boy', {
    d_boy_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    location: {
        type: DataTypes.GEOGRAPHY('POINT', 4326),
        allowNull: false
    },
    address: {
        type: DataTypes.STRING,
        allowNull: false
    },
    phone: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
            isEmail: true
        }
    },
    available: {
        type: DataTypes.BOOLEAN,
        allowNull: false
    },
}, {
    tableName: 'delivery_boy',
    timestamps: false
});


module.exports = deliveryBoy;
