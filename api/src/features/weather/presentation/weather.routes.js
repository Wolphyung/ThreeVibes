const router = require('express').Router();
const weatherController = require('./weather.controller');
const simulationController = require('./simulation.controller');

router.get('/current', weatherController.getCurrentWeather);
router.get('/forecast', weatherController.getForecast);
router.post('/simulate-alert', simulationController.simulateAlert);

module.exports = router;
