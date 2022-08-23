// use the path of your model
const TicketFiles = require("../models/ticketFilesModel");
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
describe("TicketFiles Schema test anything", () => {
  // the code below is for insert testing
  it("Add TicketFiles test", async () => {
    const data = {
      path: "Test",
      ticket: "6208b39778c0f778fc5162c5",
    };

    return await TicketFiles.create(data).then((ret) => {
      expect(ret.path).toEqual("Test");
    });
  });

  it("to test the update", async () => {
    return await TicketFiles.findOneAndUpdate(
      { path: "Test" },
      { $set: { path: "Test1" } },
      { new: true }
    ).then((ret) => {
      expect(ret.path).toEqual("Test1");
    });
  });
  //   the code below is for delete testing
  it("to test the delete TicketFiles is working or not", async () => {
    const status = await TicketFiles.findOneAndDelete(
      {},
      { sort: { _id: -1 } }
    );
    expect(status.path).toBe("Test1");
  });
});
