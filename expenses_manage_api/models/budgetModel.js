const mongoose = require("mongoose");
const validator = require("validator");

const budgetSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, "Please enter Budget name"],
  },
  amount: {
    type: mongoose.Schema.Types.Decimal128,
    required: [true, "Please enter Amount"],
  },
  total_amount: {
    type: mongoose.Schema.Types.Decimal128,
    required: [true, "Please enter Total Amount"],
  },
  created_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "Please enter created by"],
  },
});
const Budget = mongoose.model("Budget", budgetSchema);
module.exports = Budget;
