// use the path of your model
const User = require("../models/userModel");
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
describe("User Schema test anything", () => {
  // the code below is for insert testing
  it("Add user test", async () => {
    const user = {
      name: "Utsav Shrestha",
      email: "utzavshr1@gmail.com",
      password: "111111",
      passwordConfirm: "111111",
      role: "admin",
    };

    return await User.create(user).then((user_ret) => {
      expect(user_ret.email).toEqual("utzavshr1@gmail.com");
    });
  });

  it("to test the update", async () => {
    return await User.findOneAndUpdate(
      { email: "utzavshr1@gmail.com" },
      { $set: { name: "Bishal Shrestha" } },
      { new: true }
    ).then((user_ret) => {
      expect(user_ret.name).toEqual("Bishal Shrestha");
    });
  });

  //   the code below is for delete testing
  it("to test the delete user is working or not", async () => {
    const status = await User.findOneAndDelete({}, { sort: { _id: -1 } });
    expect(status.email).toBe("utzavshr1@gmail.com");
  });
});
