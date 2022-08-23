const TicketComment = require("../models/ticketCommentsModel");
const base = require("./baseController");
const mongoose = require("mongoose");

exports.deleteMe = async (req, res, next) => {
  try {
    await TicketComment.findByIdAndUpdate(req.user.id, {
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

exports.getTicketComments = async (req, res, next) => {
  try {
    let doc = await TicketComment.aggregate([
      { $match: { ticket: mongoose.Types.ObjectId(req.params.id) } },

      {
        $lookup: {
          from: "users",
          localField: "posted_by",
          foreignField: "_id",
          as: "posted_by",
        },
      },
      {
        $set: {
          posted_by: { $arrayElemAt: ["$posted_by.name", 0] },
        },
      },
    ]);
    // console.log(doc);
    // let doc = await TicketComment.find({ ticket: req.params.id });
    if (!doc) {
      return next(
        new AppError(404, "fail", "No document found with that id"),
        req,
        res,
        next
      );
    }

    res.status(200).json({
      status: "success",
      data: {
        doc,
      },
    });
  } catch (error) {
    next(error);
  }
};

// exports.getTicketComments = base.getAll(TicketComment);
// exports.getTicketComments = async (req, res, next) => {

// }
exports.getTicketComment = base.getOne(TicketComment);
exports.createTicketComment = base.createOne(TicketComment);

exports.updateTicketComment = base.updateOne(TicketComment);
exports.deleteTicketComment = base.deleteOne(TicketComment);
