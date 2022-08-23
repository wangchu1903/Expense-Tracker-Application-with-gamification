const mongoose = require("mongoose");
const validator = require("validator");

const boardSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, "Please enter Board name"],
  },
});
const Board = mongoose.model("Board", boardSchema);
module.exports = Board;
