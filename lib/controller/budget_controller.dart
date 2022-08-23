import 'dart:convert';

import 'package:expense_manager/model/budget_model.dart';
import 'package:expense_manager/model/transaction_model.dart';
import 'package:expense_manager/network/http_requests.dart';

import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';

class BudgetController extends ChangeNotifier {
  bool isLoading = true;

  String message = '';

  bool success = false;
  late HttpRequest httpRequest;
  late Budget budgetModel;
  late ApiResponse apiResponse;

  BudgetController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }

  void getBudgets() async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();

    try {
      var response = await httpRequest.getWithAuth(ApiConstants.getBudgets);
      budgetModel = Budget.fromJson(response);
      apiResponse = ApiResponse.success(false, budgetModel);
      print(apiResponse);
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not Transaction");
    }

    notifyListeners();
  }

  void delete(String id) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();

    try {
      var response =
          await httpRequest.deletetWithAuth(ApiConstants.getBudgets + "/" + id);

      success = true;
      apiResponse = ApiResponse.success(false, success);

      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not Transaction");
    }

    notifyListeners();
  }

  void createBudget(String title, String amount, String total) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();

    try {
      final Map<String, String> data = {
        "title": title,
        "amount": amount,
        "total_amount": total
      };
      var response =
          await httpRequest.postWithAuth(ApiConstants.createBudget, data);
      if (response['status'] == 'success') {
        success = true;
        apiResponse = ApiResponse.success(false, success);
      } else {
        apiResponse = ApiResponse.error(false, "Could not Transaction");
      }
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not Transaction");
    }

    notifyListeners();
  }
}
