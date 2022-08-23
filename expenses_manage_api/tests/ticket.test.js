// use the path of your model
const Ticket = require("../models/ticketModel");
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
describe("Ticket Schema test anything", () => {
  it("to test the update", async () => {
    return await Ticket.findOneAndUpdate(
      { _id: Object("6208b39778c0f778fc5162c5") },
      { $set: { state: "done" } },
      { new: true }
    ).then((ret) => {
      expect(ret.state).toEqual("done");
    });
  });
});
