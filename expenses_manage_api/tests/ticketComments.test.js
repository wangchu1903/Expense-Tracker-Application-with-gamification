// use the path of your model
const TicketComment = require("../models/ticketCommentsModel");
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
describe("TicketComment Schema test anything", () => {
  // the code below is for insert testing
  it("Add TicketComment test", async () => {
    const data = {
      content: "Test",
      ticket: "6208b39778c0f778fc5162c5",
      posted_by: "620e6db119e3d4e39a92cde5",
    };

    return await TicketComment.create(data).then((ret) => {
      expect(ret.content).toEqual("Test");
    });
  });

  it("to test the update", async () => {
    return await TicketComment.findOneAndUpdate(
      { content: "Test" },
      { $set: { content: "Test1" } },
      { new: true }
    ).then((ret) => {
      expect(ret.content).toEqual("Test1");
    });
  });
  //   the code below is for delete testing
  it("to test the delete TicketComment is working or not", async () => {
    const status = await TicketComment.findOneAndDelete(
      {},
      { sort: { _id: -1 } }
    );
    expect(status.content).toBe("Test1");
  });
});
