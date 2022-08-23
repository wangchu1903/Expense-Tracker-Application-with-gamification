const Priority = require('../models/priorityModel');
const base = require('./baseController');

exports.deleteMe = async (req, res, next) => {
    try {
        await Priority.findByIdAndUpdate(req.user.id, {
            active: false
        });

        res.status(204).json({
            status: 'success',
            data: null
        });


    } catch (error) {
        next(error);
    }
};

exports.getPrioritys = base.getAll(Priority);
exports.getPriority = base.getOne(Priority);
exports.createPriority = base.createOne(Priority);

exports.updatePriority = base.updateOne(Priority);
exports.deletePriority = base.deleteOne(Priority);