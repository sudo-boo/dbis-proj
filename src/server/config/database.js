const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize("dbisproject","postgres", "37182818", {
    host: process.env.DB_HOST || 'host',
    port: process.env.DB_PORT || 5000,
    dialect: 'postgres',
});

module.exports = sequelize;
