const mongoose = require("mongoose");
const validator = require("validator");

const ticketFilesSchema = new mongoose.Schema({
  path: {
    type: String,
    required: [true, "Please provide file path"],
  },
  ticket: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Ticket",
  },
});

const TicketFiles = mongoose.model("TicketFiles", ticketFilesSchema);
module.exports = TicketFiles;
