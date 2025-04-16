import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/constants/keys.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return "ApiException($statusCode): $message\n Data: $data";
  }
}

class BaseApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.baseUrl}/api', // Replace with your API base URL
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  BaseApi() {
    // Add interceptors if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add JWT token to request headers if available
          String? token = getStringAsync(Constants.jwtKey);
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  // Add JWT token to headers
  static void setAuthToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  // Remove JWT token from headers
  static void removeAuthToken() {
    _dio.options.headers.remove("Authorization");
  }

  // GET Request
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    print("GET: $endpoint, data: $params");
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      return Future.error(_handleError(e));
    }
  }

  // POST Request
  Future<Response> post(String endpoint, {dynamic data}) async {
    print("POST: $endpoint, data: $data");
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      print("Error: $e");
      return Future.error(_handleError(e));
    }
  }

  // PUT Request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return response;
    } catch (e) {
      return Future.error(_handleError(e));
    }
  }

  // DELETE Request
  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.delete(endpoint, data: data);
      return response;
    } catch (e) {
      return Future.error(_handleError(e));
    }
  }

  // Handle API errors
  static Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return ApiException(
          error.response?.data["message"] ?? "Unknown error",
          statusCode: error.response?.statusCode,
          data: error.response,
        );
      } else {
        throw ApiException(
          error.message ?? error.toString(),
          statusCode: error.response?.statusCode,
        );
      }
    }
    return error;
  }
}
