// use the path of your model
const Priority = require("../models/priorityModel");
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
describe("Priority Schema test anything", () => {
  // the code below is for insert testing
  it("Add Priority test", async () => {
    const priority = {
      title: "Test",
      color: "#fff",
    };

    return await Priority.create(priority).then((ret) => {
      expect(ret.title).toEqual("Test");
    });
  });

  it("to test the update", async () => {
    return await Priority.findOneAndUpdate(
      { title: "Test" },
      { $set: { title: "Test1" } },
      { new: true }
    ).then((ret) => {
      expect(ret.title).toEqual("Test1");
    });
  });
  //   the code below is for delete testing
  it("to test the delete Priority is working or not", async () => {
    const status = await Priority.findOneAndDelete({}, { sort: { _id: -1 } });
    expect(status.title).toBe("Test1");
  });
});
