import 'dart:convert';

import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/network/http_requests.dart';

import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = true;
  bool success = false;
  String message = '';

  late LoginModel loginModel;
  late HttpRequest httpRequest;

  late ApiResponse apiResponse;

  LoginController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }
  void login(String email, String password) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();
    final Map<String, String> data = {
      "email": email,
      "password": password,
    };
    try {
      var response = await httpRequest.post(ApiConstants.loginUrl, data);

      loginModel = LoginModel.fromJson(response);

      apiResponse = ApiResponse.success(false, loginModel);
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not login");
    }

    notifyListeners();
  }
}
