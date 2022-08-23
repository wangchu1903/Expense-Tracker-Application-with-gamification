const mongoose = require("mongoose");
const validator = require("validator");

const classificationSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, "Please enter Classification name"],
    },


});

const Classification = mongoose.model("Classification", classificationSchema);
module.exports = Classification;