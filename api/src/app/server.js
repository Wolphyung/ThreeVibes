const app = require("./app");
const { PORT } = require("../core/config/env");
const db = require("../core/database/db");

app.use("/api/annonces", annonceRoutes);

async function startServer() {
  try {
    // Check DB connection
    await db.query("SELECT NOW()");

    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

startServer();
