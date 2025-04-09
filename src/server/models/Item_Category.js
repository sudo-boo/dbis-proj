const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
require('dotenv').config();

const Item_Category = sequelize.define('Item_Category', {
    category_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    cat_image: {
        type: DataTypes.STRING,
        allowNull: true,
        defaultValue: process.env.IMAGE_NOT_FOUND_URL
    },
}, {
    tableName: 'item_category',
    timestamps: false
});


module.exports = Item_Category;
