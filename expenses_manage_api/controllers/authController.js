const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const User = require("../models/userModel");
const AppError = require("../utils/appError");
const sendEmail = require("../utils/sendEmail");
const {
  sendCode,
  verifyCode,
  verifyToken,
  verifyBoth,
} = require("email-verification-code");
const createToken = (id) => {
  return jwt.sign(
    {
      id,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN,
    }
  );
};

exports.forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({
      email,
    });

    if (!user) {
      return next(new AppError(401, "fail", "User not found"), req, res, next);
    }

    const data = {
      smtpInfo: {
        host: "smtp.gmail.com",
        port: 587,
        user: "car.dealership.help.desk@gmail.com",
        pass: "car.dealership321",
      },
      company: {
        name: "Expense Manager",
        email: "car.dealership.help.desk@gmail.com",
      },
      mailInfo: {
        emailReceiver: email,
        subject: "Code Confirmation",
        html(code, token) {
          return `<p>The Confirmation Code is: ${code}</p>`;
        },
      },
    };

    sendCode(data);
    res.status(200).json({
      status: "success",
    });
  } catch (err) {
    next(err);
  }
};

exports.verifyCode = async (req, res, next) => {
  try {
    const { email, code, password } = req.body;

    const user = await User.findOne({
      email,
    });

    if (!user) {
      return next(new AppError(401, "fail", "User not found"), req, res, next);
    }

    const response = verifyCode(email, code);
    if (!response.error) {
      user.password = req.body.password;
      user.passwordConfirm = req.body.password;
      await user.save();
      res.status(200).json({
        status: "success",
      });
    } else {
      return next(new AppError(401, "fail", "Invalid code"), req, res, next);
    }
  } catch (err) {
    next(err);
  }
};

exports.reset = async (req, res, next) => {
  try {
    const decode = await promisify(jwt.verify)(
      req.params.token,
      process.env.JWT_SECRET
    );

    // 3) check if the user is exist (not deleted)
    const user = await User.findById(decode.id);
    if (!user) {
      return next(
        new AppError(401, "fail", "This user is no longer exist"),
        req,
        res,
        next
      );
    }

    user.password = req.body.password;
    user.passwordConfirm = req.body.password;
    await user.save();
    res.status(200).json({
      status: "success",
    });
  } catch (err) {
    next(err);
  }
};

exports.resetToken = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return next(
        new AppError(404, "fail", "Please provide email"),
        req,
        res,
        next
      );
    }
    const usr = await User.findOne({
      email,
    });

    const token = createToken(usr.id);

    const link = `http://localhost:3001/resetpassword/${token}`;

    await sendEmail(usr.email, "Password reset", link);
    res.status(200).json({
      status: "success",
    });
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // 1) check if email and password exist
    if (!email || !password) {
      return next(
        new AppError(404, "fail", "Please provide email or password"),
        req,
        res,
        next
      );
    }

    // 2) check if user exist and password is correct
    const user = await User.findOne({
      email,
    }).select("+password");

    if (!user || !(await user.correctPassword(password, user.password))) {
      return next(
        new AppError(401, "fail", "Email or Password is wrong"),
        req,
        res,
        next
      );
    }

    // 3) All correct, send jwt to client
    const token = createToken(user.id);

    // Remove the password from the output
    user.password = undefined;

    res.status(200).json({
      status: "success",
      token,
      data: {
        user,
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.signup = async (req, res, next) => {
  try {
    const user = await User.create({
      name: req.body.name,
      email: req.body.email,
      password: req.body.password,
      passwordConfirm: req.body.passwordConfirm,
      role: req.body.role,
    });

    const token = createToken(user.id);

    user.password = undefined;

    res.status(201).json({
      status: "success",
      token,
      data: {
        user,
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.protect = async (req, res, next) => {
  try {
    // 1) check if the token is there
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }
    if (!token) {
      return next(
        new AppError(
          401,
          "fail",
          "You are not logged in! Please login in to continue"
        ),
        req,
        res,
        next
      );
    }

    // 2) Verify token
    const decode = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

    // 3) check if the user is exist (not deleted)
    const user = await User.findById(decode.id);
    if (!user) {
      return next(
        new AppError(401, "fail", "This user is no longer exist"),
        req,
        res,
        next
      );
    }

    req.user = user;
    next();
  } catch (err) {
    next(err);
  }
};

// Authorization check if the user have rights to do this action
exports.restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return next(
        new AppError(403, "fail", "You are not allowed to do this action"),
        req,
        res,
        next
      );
    }
    next();
  };
};
