const mongoose = require("mongoose");
const validator = require("validator");

const ticketSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, "Please enter ticket name"],
    },
    description: {
        type: String,
        required: [true, "Please enter ticket description"],
    },
    state: {
        type: String,
        enum: ["pending", "in_progress", "in_review", "done"],
        default: "pending",
    },
    assigned_user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    priority: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Priority'
    },
    board: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Board'
    },
    classification: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Classification'
    },
    can_staff_complete: {
        type: Boolean,
        default: false,
        select: false,
    }

});
const Ticket = mongoose.model("Ticket", ticketSchema);
module.exports = Ticket;