import 'dart:convert';

import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/network/http_requests.dart';

import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class SignupController extends ChangeNotifier {
  bool isLoading = true;
  bool success = false;
  String message = '';

  late LoginModel loginModel;
  late HttpRequest httpRequest;

  late ApiResponse apiResponse;

  SignupController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }
  void signup(String name, String email, String password) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();

    final Map<String, String> data = {
      "name": name,
      "email": email,
      "password": password,
      "passwordConfirm": password,
      "role": "admin",
    };
    try {
      var response = await httpRequest.post(ApiConstants.signupUrl, data);
      print(response);
      loginModel = LoginModel.fromJson(response);

      apiResponse = ApiResponse.success(false, loginModel);
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not Signup");
    }

    notifyListeners();
  }
}
