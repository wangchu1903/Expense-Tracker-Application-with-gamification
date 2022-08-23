const express = require("express");
const router = express.Router();
const budgetController = require("../controllers/budgetController");
const authController = require("./../controllers/authController");

// Protect all routes after this middleware
router.use(authController.protect);

router.post("/create", budgetController.createBudget);

router.route("/").get(budgetController.getBudgets);

router
  .route("/:id")
  .get(budgetController.getBudget)
  .patch(budgetController.updateBudget)
  .delete(budgetController.deleteBudget);

module.exports = router;
