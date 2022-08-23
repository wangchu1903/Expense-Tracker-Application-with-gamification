const Board = require("../models/boardModel");
const base = require("./baseController");

exports.deleteMe = async (req, res, next) => {
  try {
    await Board.findByIdAndUpdate(req.user.id, {
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

exports.getBoards = base.getAll(Board);
// exports.getBoards = async (req, res, next) => {

// }
exports.getBoard = base.getOne(Board);
exports.createBoard = base.createOne(Board);

exports.updateBoard = base.updateOne(Board);
exports.deleteBoard = base.deleteOne(Board);
