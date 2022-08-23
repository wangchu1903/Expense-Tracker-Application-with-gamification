const express = require('express');
const router = express.Router();
const classificationController = require('../controllers/classificationController');
const authController = require('./../controllers/authController');


// Protect all routes after this middleware
router.use(authController.protect);


// Only admin have permission to access for the below APIs 
router.use(authController.restrictTo('admin'));
router.post('/create', classificationController.createClassification);

router
    .route('/')
    .get(classificationController.getClassifications);

router
    .route('/:id')
    .get(classificationController.getClassification)
    .patch(classificationController.updateClassification)
    .delete(classificationController.deleteClassification);

module.exports = router;