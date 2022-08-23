import 'dart:convert';

import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/network/http_requests.dart';

import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool isLoading = true;
  bool success = false;
  String message = '';

  late LoginModel loginModel;
  late HttpRequest httpRequest;

  late ApiResponse apiResponse;

  ForgotPasswordController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }

  void forgot(String email) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();
    final Map<String, String> data = {
      "email": email,
    };
    try {
      var response = await httpRequest.post(ApiConstants.forgotPassword, data);
      if (response['status'] == 'success') {
        success = true;
      } else {
        success = false;
      }
      apiResponse = ApiResponse.loading(false);
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not login");
    }

    notifyListeners();
  }

  void verifyCode(String code, String email, password) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();
    final Map<String, String> data = {
      "email": email,
      "code": code,
      "password": password,
    };
    try {
      var response = await httpRequest.post(ApiConstants.changePassword, data);
      if (response['status'] == 'success') {
        success = true;
      } else {
        success = false;
      }
      apiResponse = ApiResponse.loading(false);
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not login");
    }

    notifyListeners();
  }
}
