const mongoose = require("mongoose");
const validator = require("validator");

const ticketCommentSchema = new mongoose.Schema({
  content: {
    type: String,
    required: [true, "Please enter comment"],
  },
  ticket: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Ticket",
  },
  posted_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
});

const TicketComment = mongoose.model("TicketComment", ticketCommentSchema);
module.exports = TicketComment;
