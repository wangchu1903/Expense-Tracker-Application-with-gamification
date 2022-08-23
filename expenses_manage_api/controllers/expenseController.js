const Expense = require("../models/expenseModel");
const base = require("./baseController");
const mongoose = require("mongoose");
const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const User = require("../models/userModel");
const Budget = require("../models/budgetModel");

exports.deleteMe = async (req, res, next) => {
  try {
    await Expense.findByIdAndUpdate(req.user.id, {
      active: false,
    });

    res.status(204).json({
      status: "success",
      data: null,
    });
  } catch (error) {
    next(error);
  }
};

exports.getAllExpenses = async (req, res, next) => {
  try {
    let user = await getUser(req);
    console.log(user._id);
    let expenses = await Expense.find({
      created_by: user._id,
    });

    res.status(200).json({
      status: "success",
      data: expenses,
    });
  } catch (error) {
    next(error);
  }
};

exports.getExpenses = async (req, res, next) => {
  try {
    let req_date = req.params.date;
    let user = await getUser(req);
    console.log(user._id);
    let expenses = await Expense.find({
      created_by: user._id,
      date: req_date,
    });

    res.status(200).json({
      status: "success",
      data: expenses,
    });
  } catch (error) {
    next(error);
  }
};
exports.getExpense = base.getOne(Expense);
async function getUser(req) {
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }
  if (!token) {
    return null;
  }

  // 2) Verify token
  const decode = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

  // 3) check if the user is exist (not deleted)
  const user = await User.findById(decode.id);
  return user;
}
exports.createExpense = async (req, res, next) => {
  try {
    var response = req.body;

    let user = await getUser(req);
    if (user == null) {
      res.status(500).json({
        status: "failed",
        data: {
          doc,
        },
      });
    } else {
      response.created_by = mongoose.Types.ObjectId(user._id);
      const doc = await Expense.create(response);
      if (req.file) {
        doc.file = req.file.filename;
        await doc.save();
      }
      const budget = await Budget.findById(response.budget);
      budget.amount = budget.amount - response.amount;
      await budget.save();
      
      const userData = await user.findOne({id: user._id});
      console.log(userData)
      await User.updateOne({id: user._id}, {points: userData.points + 20 })


      res.status(201).json({
        status: "successawaw",
        data: {
          doc,
        },
      });
    }
  } catch (error) {
    next(error);
  }
};

exports.updateExpense = base.updateOne(Expense);
exports.deleteExpense = base.deleteOne(Expense);
