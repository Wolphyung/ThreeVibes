/**
 * @swagger
 * /weather/current:
 *   get:
 *     tags: [Weather]
 *     summary: Get current weather for Fianarantsoa
 *     description: Returns current temperature, precipitation, wind speed, and weather code for Fianarantsoa, Madagascar.
 *     responses:
 *       200:
 *         description: Current weather data
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 city:
 *                   type: string
 *                 data:
 *                   type: object
 *                   properties:
 *                     temperature_2m:
 *                       type: number
 *                     wind_speed_10m:
 *                       type: number
 *                     precipitation:
 *                       type: number
 *                     weather_code:
 *                       type: integer
 * 
 * /weather/forecast:
 *   get:
 *     tags: [Weather]
 *     summary: Get 7-day weather forecast for Fianarantsoa with alert levels
 *     responses:
 *       200:
 *         description: 7-day weather forecast data
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 city:
 *                   type: string
 *                 forecast:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       date:
 *                         type: string
 *                       maxTemp:
 *                         type: number
 *                       minTemp:
 *                         type: number
 *                       precipitation:
 *                         type: number
 *                       maxWindSpeed:
 *                         type: number
 *                       weatherCode:
 *                         type: integer
 *                       alertLevel:
 *                         type: integer
 *                         description: "0: Green, 1: Yellow, 2: Orange, 3: Red"
 *                       alertLabel:
 *                         type: string
 * 
 * /weather/simulate-alert:
 *   post:
 *     tags: [Weather]
 *     summary: Simulate a weather alert for testing (Socket.IO)
 *     description: Manually triggers a weather-alert event to all connected Socket.IO clients.
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               type:
 *                 type: string
 *                 example: "WIND_ALERT"
 *               message:
 *                 type: string
 *                 example: "Ceci est un test d'alerte vent fort."
 *               data:
 *                 type: object
 *                 properties:
 *                   windSpeed:
 *                     type: number
 *                     example: 75
 *     responses:
 *       200:
 *         description: Alert broadcasted successfully
 */
