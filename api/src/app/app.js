const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("../core/config/swagger");
const routes = require("../routes");
const annonceRoutes = require("../features/annonce/presentation/annonce.routes");
require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env') });


const app = express();

// Middlewares
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Swagger documentation
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Routes spécifiques aux annonces
app.use("/api/annonces", annonceRoutes);

// Autres routes de l'index
app.use("/api", routes);

// Base route
<<<<<<< HEAD
app.get("/", (req, res) => {
  res.json({ message: "Welcome to ThreeVibes API" });
=======
app.get('/', (req, res) => {
  res.json({ message: 'API fonctionnelle' });
>>>>>>> nyantsa
});

// Error handling middleware
app.use((err, req, res, next) => {
<<<<<<< HEAD
  console.error(err.stack);
  res.status(500).json({ error: "Something went wrong!" });
=======
  console.error(err.message);
  res.status(err.status || 500).json({ error: err.message });
>>>>>>> nyantsa
});

module.exports = app;