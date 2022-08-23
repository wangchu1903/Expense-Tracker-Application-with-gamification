// use the path of your model
const Board = require("../models/boardModel");
const mongoose = require("mongoose");
// use the new name of the database
const url = "mongodb://localhost:27017/TicketingSystem";
beforeAll(async () => {
  await mongoose.connect(url, {
    useNewUrlParser: true,
  });
});
afterAll(async () => {
  await mongoose.connection.close();
});
describe("Board Schema test anything", () => {
  // the code below is for insert testing
  it("Add board test", async () => {
    const board = {
      title: "Test",
    };

    return await Board.create(board).then((board_ret) => {
      expect(board_ret.title).toEqual("Test");
    });
  });

  it("to test the update", async () => {
    return await Board.findOneAndUpdate(
      { title: "Test" },
      { $set: { title: "Test1" } },
      { new: true }
    ).then((user_ret) => {
      expect(user_ret.title).toEqual("Test1");
    });
  });
  //   the code below is for delete testing
  it("to test the delete board is working or not", async () => {
    const status = await Board.findOneAndDelete({}, { sort: { _id: -1 } });
    expect(status.title).toBe("Test1");
  });
});
