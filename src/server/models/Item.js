const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Item = sequelize.define('Item', {
    product_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    brand: {
        type: DataTypes.STRING,
        allowNull: false
    },
    mrp: {
        type: DataTypes.FLOAT,
        allowNull: false,
        validate: {
            min: 0
        }
    },
    quantity: {
        type: DataTypes.STRING,
        allowNull: false
    },
    discount: {
        type: DataTypes.FLOAT,
        allowNull: false,
        validate: {
            min: 0,
            max: 100
        }
    },
    description: {
        type: DataTypes.TEXT,
        allowNull: true
    },
    image_url: {
        type: DataTypes.ARRAY(DataTypes.STRING),
        allowNull: true,
        defaultValue: []
    },
    rating: {
        type: DataTypes.FLOAT,
        allowNull: true,
        validate: {
            min: 0,
            max: 5
        }
    },
    highlights: {
        type: DataTypes.JSON,
        allowNull: true
    },
    category: {
        type: DataTypes.INTEGER,
        references: {
            model: 'item_category',
            key: 'category_id'
        }
    }
}, {
    tableName: 'item',
    timestamps: false
});


module.exports = Item;
