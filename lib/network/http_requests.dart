import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_manager/utils/save_data.dart';
import '../../utils/exceptions.dart';

/// Handles all sort of WebAPI calls using a dio library
class HttpRequest {
  // Creating a singleton
  static final HttpRequest _httpRequest = HttpRequest._internal();
  late Dio dio;
  factory HttpRequest() {
    return _httpRequest;
  }

  HttpRequest._internal() {
    dio = Dio();
  }
  // Handles get request
  Future<dynamic> get(url) async {
    Response response;
    try {
      response = await dio.get(url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return _response(response);
  }

  // handles post reqests
  Future<dynamic> post(url, Map param) async {
    Response response;
    try {
      print(param);
      print(url);
      response = await dio.post(url, data: param);
      print(response.data);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return _response(response);
  }

  // handles delete requests
  Future<dynamic> deletetWithAuth(url) async {
    Response response;
    try {
      final token = await SaveData.getToken();
      response = await dio.delete(
        url,
        options: Options(
          headers: {
            "authorization": "Bearer " + token,
          },
        ),
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return _response(response);
  }

  // handles get with auth
  Future<dynamic> getWithAuth(url) async {
    Response response;
    try {
      final token = await SaveData.getToken();
      response = await dio.get(
        url,
        options: Options(
          headers: {
            "authorization": "Bearer " + token,
          },
        ),
      );
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  // handles patch with auth
  Future<dynamic> patchWithAuth(url, Map param) async {
    Response response;
    try {
      print(param);
      print(url);
      final token = await SaveData.getToken();
      response = await dio.patch(
        url,
        data: param,
        options: Options(
          headers: {
            "authorization": "Bearer " + token,
          },
        ),
      );
      print(response.data);
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  // handles post with auth
  Future<dynamic> postWithAuth(url, Map param) async {
    Response response;
    try {
      print(param);
      print(url);
      final token = await SaveData.getToken();
      response = await dio.post(
        url,
        data: param,
        options: Options(
          headers: {
            "authorization": "Bearer " + token,
          },
        ),
      );
      print(response.data);
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postMultiPart(url, Map<String, dynamic> param) async {
    Response response;
    try {
      print(param);
      print(url);
      final token = await SaveData.getToken();

      dio.options.headers["Content-Type"] = "multipart/form-data";
      FormData formData = FormData.fromMap(param);

      response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "authorization": "Bearer " + token,
          },
        ),
      );
      print(response.data);
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data);
      case 401:
      case 403:
        throw UnauthorisedException(response.data);
      case 500:
      default:
        print(response.data);
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
