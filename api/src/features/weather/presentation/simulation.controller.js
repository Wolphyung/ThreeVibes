const notificationService = require('../../notifications/notification.service');

class SimulationController {
  /**
   * Simulate a weather alert and broadcast it to all users.
   */
  simulateAlert = async (req, res) => {
    try {
      const { data } = req.body;

      const alertType = type || 'SIMULATED_ALERT';
      const alertMessage = message || 'Ceci est une alerte météo simulée pour test.';
      const alertData = data || {
        temperature: 25,
        windSpeed: 70,
        precipitation: 15,
        weatherCode: 95
      };

      console.log(`[SIMULATION] Triggering manual alert: ${alertMessage}`);
      
      notificationService.broadcast('weather-alert', {
        type: alertType,
        message: alertMessage,
        data: alertData,
        isSimulated: true
      });

      res.status(200).json({
        success: true,
        message: 'Simulated alert broadcasted successfully',
        details: { type: alertType, message: alertMessage }
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
}

module.exports = new SimulationController();
