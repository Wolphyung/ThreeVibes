const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const routes = require("../routes");

const app = express();

// Middlewares
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const annonceRoutes = require("../features/annonce/presentation/annonce.routes");

app.use("/api/annonces", annonceRoutes);

// Routes
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
