const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });
const verifyToken = require("../../../middlewares/auth.middleware");
const router = require("express").Router();

const {
  register,
  login,
  update,
  remove,
  forgotPassword,
  resetPassword,
  getMe,
  getAll,
  listFonctions,
  getFonction,
  createFonction,
  updateFonction,
  deleteFonction,
} = require("./user.controller");

// --- AUTHENTICATION ---
router.post("/register", upload.single("image"), register);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.post("/reset-password", resetPassword);

// --- PROFILE & USERS ---
router.get("/me", verifyToken, getMe);
router.get("/", getAll);
router.put("/:id", upload.single("image"), update);
router.delete("/:id", remove);

// --- FONCTION ROUTES ---
router.get("/fonctions", listFonctions);
router.get("/fonctions/:id", getFonction);
router.post("/fonctions", createFonction);
router.put("/fonctions/:id", updateFonction);
router.delete("/fonctions/:id", deleteFonction);

module.exports = router;
