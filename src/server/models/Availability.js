const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Availability = sequelize.define('Availability', {
    vendor_id: {
        type: DataTypes.INTEGER,
        references: {
            model: 'vendor',
            key: 'vendor_id'
        }
    },
    product_id: {
        type: DataTypes.INTEGER,
        references: {
            model: 'item',
            key: 'product_id'
        }
    },
    quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
            min: 0
        }
    }
}, {
    tableName: 'availability',
    timestamps: false,
    primaryKey: false,
    indexes: [
        {
            unique: true,
            fields: ['vendor_id', 'product_id']
        }
    ]
});


module.exports = Availability;
