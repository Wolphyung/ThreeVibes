const http = require("http");
const app = require("./app");
const { PORT } = require("../core/config/env");
const db = require("../core/database/db");
const { initSocket } = require("../core/socket");
const weatherService = require("../features/weather/domain/weather.service");
require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env') });

async function startServer() {
  try {
    // 1. Vérification de la connexion DB
    await db.query("SELECT NOW()");
    console.log("Database connected successfully.");

    // 2. Création du serveur HTTP à partir de l'app Express
    const server = http.createServer(app);

    // 3. Initialisation de Socket.IO sur ce serveur
    initSocket(server);

    // 4. Initialisation du système d'alerte météo
    weatherService.init();

    // 5. Lancement du serveur unique
    server.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
      console.log(`Socket.IO is ready for connections`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

startServer();