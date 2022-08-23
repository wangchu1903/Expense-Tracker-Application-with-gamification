const mongoose = require("mongoose");
const validator = require("validator");

const prioritySchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, "Please enter Priority name"],
  },
  color: {
    type: String,
    required: [true, "Please select Priority color"],
  },
});
const Priority = mongoose.model("Priority", prioritySchema);
module.exports = Priority;
