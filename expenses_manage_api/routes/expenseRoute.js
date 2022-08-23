const express = require("express");
const router = express.Router();
const expenseController = require("../controllers/expenseController");
const authController = require("./../controllers/authController");
const multer = require("multer");
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "./public");
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage });
// Protect all routes after this middleware
router.use(authController.protect);

router.post("/create", upload.single("file"), expenseController.createExpense);

router.route("/:date").get(expenseController.getExpenses);
router.route("/").get(expenseController.getAllExpenses);

router
  .route("/:id")
  .get(expenseController.getExpense)
  .patch(expenseController.updateExpense)
  .delete(expenseController.deleteExpense);

module.exports = router;
