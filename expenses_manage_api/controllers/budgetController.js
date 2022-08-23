const Budget = require("../models/budgetModel");
const base = require("./baseController");
const mongoose = require("mongoose");
const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const User = require("../models/userModel");

exports.deleteMe = async (req, res, next) => {
  try {
    await Budget.findByIdAndUpdate(req.user.id, {
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

exports.getBudgets = async (req, res, next) => {
  try {
    let req_date = req.params.date;
    let user = await getUser(req);
    console.log(user._id);
    let expenses = await Budget.find({
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
exports.getBudget = base.getOne(Budget);
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
exports.createBudget = async (req, res, next) => {
  try {
    var response = req.body;
    console.log(response);
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
      const doc = await Budget.create(response);

      res.status(201).json({
        status: "success",
        data: {
          doc,
        },
      });
    }
  } catch (error) {
    next(error);
  }
};

exports.updateBudget = base.updateOne(Budget);
exports.deleteBudget = base.deleteOne(Budget);
