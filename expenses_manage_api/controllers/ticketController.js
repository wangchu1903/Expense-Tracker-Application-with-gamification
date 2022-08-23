const Ticket = require("../models/ticketModel");
const TicketFiles = require("../models/ticketFilesModel");
const base = require("./baseController");
const mongoose = require("mongoose");

exports.deleteMe = async (req, res, next) => {
  try {
    await Ticket.findByIdAndUpdate(req.user.id, {
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

exports.getTickets = async (req, res, next) => {
  try {
    const data = await Ticket.aggregate([
      {
        $lookup: {
          from: "users",
          localField: "assigned_user",
          foreignField: "_id",
          as: "assigned_user",
        },
      },
      {
        $lookup: {
          from: "ticketfiles",
          localField: "_id",
          foreignField: "ticket",
          as: "file",
        },
      },
      {
        $lookup: {
          from: "priorities",
          localField: "priority",
          foreignField: "_id",
          as: "priority",
        },
      },
      {
        $lookup: {
          from: "boards",
          localField: "board",
          foreignField: "_id",
          as: "board",
        },
      },
      {
        $lookup: {
          from: "classifications",
          localField: "classification",
          foreignField: "_id",
          as: "classification",
        },
      },
      {
        $set: {
          assigned_user: { $arrayElemAt: ["$assigned_user.email", 0] },
        },
      },
      {
        $set: {
          board: { $arrayElemAt: ["$board.title", 0] },
        },
      },
      {
        $set: {
          classification: { $arrayElemAt: ["$classification.title", 0] },
        },
      },
      {
        $set: {
          file: { $arrayElemAt: ["$file.path", 0] },
        },
      },
      {
        $unwind: "$priority",
      },
    ]);

    if (!data) {
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
        data,
      },
    });
  } catch (error) {
    next(error);
  }
};

exports.getTicket = async (req, res, next) => {
  try {
    const data = await Ticket.aggregate([
      { $match: { _id: mongoose.Types.ObjectId(req.params.id) } },
      {
        $lookup: {
          from: "users",
          localField: "assigned_user",
          foreignField: "_id",
          as: "assigned_user",
        },
      },
      {
        $lookup: {
          from: "priorities",
          localField: "priority",
          foreignField: "_id",
          as: "priority",
        },
      },
      {
        $lookup: {
          from: "boards",
          localField: "board",
          foreignField: "_id",
          as: "board",
        },
      },
      {
        $lookup: {
          from: "classifications",
          localField: "classification",
          foreignField: "_id",
          as: "classification",
        },
      },
      {
        $set: {
          assigned_user: { $arrayElemAt: ["$assigned_user.email", 0] },
        },
      },
      {
        $set: {
          board: { $arrayElemAt: ["$board.title", 0] },
        },
      },
      {
        $set: {
          classification: { $arrayElemAt: ["$classification.title", 0] },
        },
      },
      {
        $unwind: "$priority",
      },
    ]);

    if (!data) {
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
        data,
      },
    });
  } catch (error) {
    next(error);
  }
};

exports.getTicketForBoard = async (req, res, next) => {
  try {
    const data = await Ticket.aggregate([
      { $match: { board: mongoose.Types.ObjectId(req.params.id) } },
      {
        $lookup: {
          from: "users",
          localField: "assigned_user",
          foreignField: "_id",
          as: "assigned_user",
        },
      },
      {
        $lookup: {
          from: "priorities",
          localField: "priority",
          foreignField: "_id",
          as: "priority",
        },
      },
      {
        $lookup: {
          from: "boards",
          localField: "board",
          foreignField: "_id",
          as: "board",
        },
      },
      {
        $lookup: {
          from: "classifications",
          localField: "classification",
          foreignField: "_id",
          as: "classification",
        },
      },
      {
        $set: {
          assigned_user: { $arrayElemAt: ["$assigned_user.email", 0] },
        },
      },
      {
        $set: {
          board: { $arrayElemAt: ["$board.title", 0] },
        },
      },
      {
        $set: {
          classification: { $arrayElemAt: ["$classification.title", 0] },
        },
      },
      {
        $unwind: "$priority",
      },
    ]);

    if (!data) {
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
        data,
      },
    });
  } catch (error) {
    next(error);
  }
};

exports.createTicket = async (req, res, next) => {
  try {
    var response = req.body;
    console.log(response);
    response.assigned_user = mongoose.Types.ObjectId(response.assigned_user);

    response.priority = mongoose.Types.ObjectId(response.priority);
    response.board = mongoose.Types.ObjectId(response.board);
    response.classification = mongoose.Types.ObjectId(response.classification);
    console.log(response);
    const doc = await Ticket.create(response);
    if (req.file) {
      const fileEntry = await TicketFiles.create({
        path: req.file.filename,
        ticket: doc._id,
      });
    }
    res.status(201).json({
      status: "success",
      data: {
        doc,
      },
    });
  } catch (error) {
    next(error);
  }
};
// exports.createTicket = base.createOne(Ticket);

exports.updateTicket = async (req, res, next) => {
  try {
    var response = req.body;
    console.log(response);

    if (response.assigned_user)
      response.assigned_user = mongoose.Types.ObjectId(response.assigned_user);

    if (response.priority)
      response.priority = mongoose.Types.ObjectId(response.priority);
    if (response.board)
      response.board = mongoose.Types.ObjectId(response.board);
    if (response.classification)
      response.classification = mongoose.Types.ObjectId(
        response.classification
      );

    const doc = await Ticket.findByIdAndUpdate(req.params.id, response);
    if (req.file) {
      const fileEntry = await TicketFiles.create({
        path: req.file.filename,
        ticket: doc._id,
      });
    }
    res.status(201).json({
      status: "success",
      data: {
        doc,
      },
    });
  } catch (error) {
    next(error);
  }
};

exports.moveTicket = base.updateOne(Ticket);
exports.deleteTicket = base.deleteOne(Ticket);
