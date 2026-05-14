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

// Main API routes (includes annonces, users, weather, etc.)
app.use("/api", routes);

// Base route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to ThreeVibes API" });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Something went wrong!" });
});

module.exports = app;