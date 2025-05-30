const Vendor = require('../models/Vendor');
const { literal } = require('sequelize');

const Op = require('sequelize').Op;

async function getNearestVendor(userLatitude, userLongitude, maxDistance, l = 1) {

    // fetch the nearest vendor to the user location whose distance must be lesser than maxDistance
    userLatitude = parseFloat(userLatitude);
    userLongitude = parseFloat(userLongitude);
    vendors = await Vendor.findAll({
        attributes: [
            'vendor_id',
            'name',
            [literal(`ST_Y(location::geometry)`), 'latitude'],
            [literal(`ST_X(location::geometry)`), 'longitude'],
            [literal(`ST_Distance(location, ST_SetSRID(ST_MakePoint(${userLongitude}, ${userLatitude}), 4326))`), 'distance']
        ],
        where: {
            available: true,
            [Op.and]: literal(`
            ST_DWithin(
                location,
                ST_SetSRID(ST_MakePoint(${userLatitude}, ${userLongitude}), 4326),
                ${maxDistance * 1000}
            )
        `)},
        order: [[literal('distance'), 'ASC']],
        limit: l
    });
    return vendors;
}

module.exports = getNearestVendor;