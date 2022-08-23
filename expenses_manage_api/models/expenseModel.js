const mongoose = require("mongoose");
const validator = require("validator");

const expenseSchema = new mongoose.Schema({
  payee_name: {
    type: String,
    required: [true, "Please enter Payee name"],
  },
  type: {
    type: String,
    required: [true, "Please enter Transaction Type"],
    enum: ["INCOME", "EXPENSE"],
    default: "EXPENSE",
  },
  amount: {
    type: String,
    required: [true, "Please enter Amount"],
  },
  date: {
    type: Date,
    required: [true, "Please enter Date"],
  },
  created_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "Please enter created by"],
  },
  file: {
    type: String,
  },
});
const Expense = mongoose.model("Expense", expenseSchema);
module.exports = Expense;
