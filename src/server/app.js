require('dotenv').config();
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || 'My Express App';


app.use(express.json());

app.get('/', (req, res) => {
    res.send(`Welcome to ${APP_NAME} running on port ${PORT}`);
});

app.listen(PORT, () => {
    console.log(`${APP_NAME} is running on http://localhost:${PORT}`);
});