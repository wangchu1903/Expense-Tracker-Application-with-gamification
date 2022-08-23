const express = require("express");
const router = express.Router();
const TicketController = require("../controllers/ticketController");
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
router.route("/").get(TicketController.getTickets);
router.patch("/moveTicket/:id", TicketController.moveTicket);

// Only admin have permission to access for the below APIs
router.use(authController.restrictTo("admin"));

router.post("/create", upload.single("file"), TicketController.createTicket);
router.route("/ticketForBoard/:id").get(TicketController.getTicketForBoard);

router
  .route("/:id")
  .get(TicketController.getTicket)
  .patch(upload.single("file"), TicketController.updateTicket)
  .delete(TicketController.deleteTicket);

module.exports = router;
