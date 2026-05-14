const weatherService = require('../domain/weather.service');

class WeatherController {
  getCurrentWeather = async (req, res) => {
    try {
      const weather = await weatherService.getCurrentWeather();
      res.json({
        city: 'Fianarantsoa',
        data: weather
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  getForecast = async (req, res) => {
    try {
      const forecast = await weatherService.getForecast();
      res.json({
        city: 'Fianarantsoa',
        forecast: forecast
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
}

module.exports = new WeatherController();
