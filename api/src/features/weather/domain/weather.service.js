const axios = require('axios');
const cron = require('node-cron');
const notificationService = require('../../notifications/notification.service');

class WeatherService {
  constructor() {
    this.lat = -21.4536;
    this.lon = 47.0858;
    this.apiUrl = 'https://api.open-meteo.com/v1/forecast';
  }

  /**
   * Initialize the weather checking system.
   * Checks every hour.
   */
  init() {
    console.log('Weather alert system initialized for Fianarantsoa.');
    
    // Schedule check every hour
    cron.schedule('0 * * * *', () => {
      this.checkWeather();
    });

    // Initial check on startup
    this.checkWeather();
  }

  /**
   * Fetch weather data and notify if alerts are needed.
   */
  async checkWeather() {
    try {
      const response = await axios.get(this.apiUrl, {
        params: {
          latitude: this.lat,
          longitude: this.lon,
          current: 'temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m,weather_code',
          timezone: 'auto'
        }
      });

      const current = response.data.current;
      if (!current) return;

      const { temperature_2m, precipitation, wind_speed_10m, weather_code } = current;

      let alertMessage = null;
      let alertType = 'INFO';

      // Define alert conditions
      if (wind_speed_10m > 60) {
        alertMessage = `Alerte Vent Fort à Fianarantsoa: ${wind_speed_10m} km/h. Prudence!`;
        alertType = 'WIND_ALERT';
      } else if (precipitation > 10) {
        alertMessage = `Alerte Pluie Intense à Fianarantsoa: ${precipitation} mm. Risque d'inondations.`;
        alertType = 'RAIN_ALERT';
      } else if (weather_code >= 95) {
        alertMessage = `Alerte Orage à Fianarantsoa. Mettez-vous à l'abri.`;
        alertType = 'THUNDERSTORM_ALERT';
      }

      if (alertMessage) {
        console.log(`Weather Alert Detected: ${alertMessage}`);
        notificationService.broadcast('weather-alert', {
          type: alertType,
          message: alertMessage,
          data: {
            temperature: temperature_2m,
            windSpeed: wind_speed_10m,
            precipitation: precipitation,
            weatherCode: weather_code
          }
        });
      } else {
        console.log(`Weather check for Fianarantsoa: OK (${temperature_2m}°C, Wind: ${wind_speed_10m} km/h)`);
      }

    } catch (error) {
      console.error('Error checking weather:', error.message);
    }
  }

  /**
   * Get current weather for manual requests
   */
  async getCurrentWeather() {
    const response = await axios.get(this.apiUrl, {
      params: {
        latitude: this.lat,
        longitude: this.lon,
        current: 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,wind_speed_10m,weather_code',
        timezone: 'auto'
      }
    });
    return response.data.current;
  }

  /**
   * Get 7-day forecast with alert levels
   */
  async getForecast() {
    const response = await axios.get(this.apiUrl, {
      params: {
        latitude: this.lat,
        longitude: this.lon,
        daily: 'temperature_2m_max,temperature_2m_min,precipitation_sum,wind_speed_10m_max,weather_code',
        timezone: 'auto'
      }
    });

    const daily = response.data.daily;
    const forecast = daily.time.map((date, index) => {
      const data = {
        date,
        maxTemp: daily.temperature_2m_max[index],
        minTemp: daily.temperature_2m_min[index],
        precipitation: daily.precipitation_sum[index],
        maxWindSpeed: daily.wind_speed_10m_max[index],
        weatherCode: daily.weather_code[index]
      };

      const { level, label } = this.calculateAlertLevel(data);
      return { ...data, alertLevel: level, alertLabel: label };
    });

    return forecast;
  }

  /**
   * Calculate alert level based on daily metrics
   * @returns {object} { level: 0-3, label: string }
   */
  calculateAlertLevel(dayData) {
    const { maxWindSpeed, precipitation, weatherCode } = dayData;

    // Red Alert (Level 3)
    if (maxWindSpeed > 80 || precipitation > 50 || weatherCode >= 95) {
      return { level: 3, label: 'RED' };
    }
    // Orange Alert (Level 2)
    if (maxWindSpeed > 50 || precipitation > 20 || (weatherCode >= 80 && weatherCode <= 90)) {
      return { level: 2, label: 'ORANGE' };
    }
    // Yellow Alert (Level 1)
    if (maxWindSpeed > 30 || precipitation > 5 || (weatherCode >= 50 && weatherCode <= 67)) {
      return { level: 1, label: 'YELLOW' };
    }
    // Green (Level 0)
    return { level: 0, label: 'GREEN' };
  }
}

module.exports = new WeatherService();
