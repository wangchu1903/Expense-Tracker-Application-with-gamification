const express = require('express');
const router = express.Router();
const priorityController = require('../controllers/priorityController');
const authController = require('./../controllers/authController');


// Protect all routes after this middleware
router.use(authController.protect);


// Only admin have permission to access for the below APIs 
router.use(authController.restrictTo('admin'));
router.post('/create', priorityController.createPriority);

router
    .route('/')
    .get(priorityController.getPrioritys);

router
    .route('/:id')
    .get(priorityController.getPriority)
    .patch(priorityController.updatePriority)
    .delete(priorityController.deletePriority);

module.exports = router;