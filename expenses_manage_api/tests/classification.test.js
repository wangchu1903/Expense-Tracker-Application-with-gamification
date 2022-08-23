// use the path of your model
const Classification = require("../models/classificationModel");
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
describe("Classification Schema test anything", () => {
  // the code below is for insert testing
  it("Add Classification test", async () => {
    const data = {
      title: "Test",
    };

    return await Classification.create(data).then((ret) => {
      expect(ret.title).toEqual("Test");
    });
  });

  it("to test the update", async () => {
    return await Classification.findOneAndUpdate(
      { title: "Test" },
      { $set: { title: "Test1" } },
      { new: true }
    ).then((ret) => {
      expect(ret.title).toEqual("Test1");
    });
  });
  //   the code below is for delete testing
  it("to test the delete Classification is working or not", async () => {
    const status = await Classification.findOneAndDelete(
      {},
      { sort: { _id: -1 } }
    );
    expect(status.title).toBe("Test1");
  });
});
