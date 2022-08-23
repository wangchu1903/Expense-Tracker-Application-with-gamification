const express = require("express");
const router = express.Router();
const ticketCommentsController = require("../controllers/ticketCommentController");
const authController = require("./../controllers/authController");

// Protect all routes after this middleware
router.use(authController.protect);

// Only admin have permission to access for the below APIs
// router.use(authController.restrictTo("admin"));
router.post("/create", ticketCommentsController.createTicketComment);

router.route("/:id").get(ticketCommentsController.getTicketComments);

router
  .route("/:id")
  .get(ticketCommentsController.getTicketComment)
  .patch(ticketCommentsController.updateTicketComment)
  .delete(ticketCommentsController.deleteMe);

module.exports = router;
