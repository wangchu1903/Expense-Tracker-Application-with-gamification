const express = require("express");
const router = express.Router();
const boardController = require("../controllers/boardController");
const authController = require("./../controllers/authController");

// Protect all routes after this middleware
router.use(authController.protect);

router.route("/").get(boardController.getBoards);
// Only admin have permission to access for the below APIs
router.use(authController.restrictTo("admin"));
router.post("/create", boardController.createBoard);

router
  .route("/:id")
  .get(boardController.getBoard)
  .patch(boardController.updateBoard)
  .delete(boardController.deleteBoard);

module.exports = router;
