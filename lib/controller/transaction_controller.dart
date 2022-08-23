import 'dart:convert';

import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/network/http_requests.dart';
import 'package:dio/dio.dart';
import 'package:expense_manager/utils/api_constants.dart';
import 'package:expense_manager/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class TransactionController extends ChangeNotifier {
  bool isLoading = true;

  String message = '';

  bool success = false;
  late HttpRequest httpRequest;

  late ApiResponse apiResponse;

  TransactionController() {
    apiResponse = ApiResponse.loading(false);
    httpRequest = HttpRequest();
  }

  void updateTransaction(String payeeName, String amount, String date,
      String transactionType, String id) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();
    Map<String, dynamic> data = {
      "payee_name": payeeName,
      "amount": amount,
      "date": date,
      "type": transactionType.toUpperCase(),
    };

    try {
      var response = await httpRequest.patchWithAuth(
          ApiConstants.getTransaction + id, data);
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

  void transaction(String payeeName, String amount, String date,
      String transactionType, String budget,
      {String file = ""}) async {
    apiResponse = ApiResponse.loading(true);
    notifyListeners();

    Map<String, dynamic> data = {};
    if (file.isNotEmpty) {
      String? mimeType = mime(file);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      data = {
        "payee_name": payeeName,
        "amount": amount,
        "date": date,
        "budget": budget,
        "type": transactionType.toUpperCase(),
        'file': await MultipartFile.fromFile(file,
            filename: file, contentType: MediaType(mimee, type))
      };
    } else {
      data = {
        "payee_name": payeeName,
        "amount": amount,
        "date": date,
        "budget": budget,
        "type": transactionType.toUpperCase(),
      };
    }

    try {
      var response =
          await httpRequest.postMultiPart(ApiConstants.createTransaction, data);
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
