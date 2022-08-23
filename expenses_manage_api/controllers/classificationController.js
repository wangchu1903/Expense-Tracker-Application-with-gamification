const Classification = require('../models/classificationModel');
const base = require('./baseController');

exports.deleteMe = async (req, res, next) => {
    try {
        await Classification.findByIdAndUpdate(req.user.id, {
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

exports.getClassifications = base.getAll(Classification);
exports.getClassification = base.getOne(Classification);
exports.createClassification = base.createOne(Classification);

exports.updateClassification = base.updateOne(Classification);
exports.deleteClassification = base.deleteOne(Classification);