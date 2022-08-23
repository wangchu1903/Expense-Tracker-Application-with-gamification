import 'dart:convert';

import 'package:expense_manager/model/transaction_model.dart';
import 'package:expense_manager/network/http_requests.dart';

import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class StatsController extends ChangeNotifier {
  bool isLoading = true;

  String message = '';

  bool success = false;
  late HttpRequest httpRequest;
  late Transaction transactionModel;
  List<Data> transactions = [];
  late ApiResponse apiResponse;

  StatsController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }

  void getExpenses() async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();
    try {
      var response = await httpRequest.getWithAuth(ApiConstants.getTransaction);
      transactionModel = Transaction.fromJson(response);
      apiResponse = ApiResponse.success(false, transactionModel);
      transactions = transactionModel.data;
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
      apiResponse = ApiResponse.error(false, "Could not Transaction");
    }

    notifyListeners();
  }
}
