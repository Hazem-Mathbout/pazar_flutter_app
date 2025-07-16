import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/routes/app_pages.dart';

class DataLayer extends GetxService {
  // static const String _baseUrl = 'https://bazar-dev.amrhajjouz.com/api';
  static const String _baseUrl = 'https://api.pazarcom.com/api';
  late dio.Dio _dio;

  String? _token;

  DataLayer() {
    _dio = dio.Dio(dio.BaseOptions(baseUrl: _baseUrl));
  }

  dio.Options _buildHeaders(String endpoint, String method) {
    final isPublic = isPublicRoute(endpoint, method);
    return dio.Options(
      headers: isPublic ? null : {'Authorization': 'Bearer $_token'},
    );
  }

  void _guardProtectedRoute(String endpoint, String method) {
    if (!isPublicRoute(endpoint, method) &&
        (_token == null || _token!.isEmpty)) {
      Get.toNamed(Routes.AUTH);
      throw Exception('Unauthorized token is:$_token. Redirecting to login.');
    }
  }

  Future<dio.Response<dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    _guardProtectedRoute(endpoint, 'get');

    final cleanedParams = _cleanQueryParameters(queryParameters);

    log('Cleaned queryParameters: $cleanedParams');

    try {
      final dio.Response response = await _dio.get(
        endpoint,
        queryParameters: cleanedParams,
        options: _buildHeaders(endpoint, 'get'),
      );
      return response;
    } on dio.DioException catch (e) {
      // Handle Dio errors
      print('DioError: $e');
      rethrow;
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      rethrow;
    }
  }

  Future<dio.Response<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _guardProtectedRoute(endpoint, 'post');
    try {
      final dio.Response response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildHeaders(endpoint, 'post'),
      );
      return response;
    } on dio.DioException catch (e) {
      print('DioError: $e');
      rethrow;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<dio.Response<dynamic>> postFormData(
    String endpoint, {
    required dio.FormData formData,
    Map<String, dynamic>? queryParameters,
  }) async {
    _guardProtectedRoute(endpoint, 'post');

    try {
      final dio.Response response = await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: _buildHeaders(endpoint, 'post'),
      );
      return response;
    } on dio.DioException catch (e) {
      print('DioError: $e');
      rethrow;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<dio.Response<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _guardProtectedRoute(endpoint, 'put');

    try {
      final dio.Response response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildHeaders(endpoint, 'put'),
      );
      return response;
    } on dio.DioException catch (e) {
      print('DioError: $e');
      rethrow;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<dio.Response<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    _guardProtectedRoute(endpoint, 'delete');

    try {
      final dio.Response response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildHeaders(endpoint, 'delete'),
      );
      return response;
    } on dio.DioException catch (e) {
      print('DioError: $e');
      rethrow;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> setToken(String? token) async {
    _token = token;
  }

  // Example method to check if the user is logged in
  bool isLoggedIn() {
    final utilitiesService = Get.find<UtilitiesService>();
    final prefs = utilitiesService.prefs;
    final token = prefs.getString('token');
    final userInfo = prefs.getString('user');
    _token = token;
    return token != null &&
        token.isNotEmpty &&
        userInfo != null &&
        userInfo.isNotEmpty;
  }

  bool isPublicRoute(String endpoint, String method) {
    final publicRoutes = <String, List<RegExp>>{
      'GET': [
        RegExp(r"^/utilities"),
        RegExp(r"^/makes/?([^/]+)?/models$"), // matches /makes/{value}/models
        RegExp(r"^/makes"),
        RegExp(r"^/contents"),
        RegExp(r"^/advertisements$"),
        RegExp(r"^/advertisements/\d+$"),
      ],
      // Define other methods if needed
      'POST': [
        RegExp(r"^/users$"),
        RegExp(r"^/users/authenticate$"),
      ],
    };

    final patterns = publicRoutes[method.toUpperCase()];
    if (patterns == null) return false;

    return patterns.any((pattern) => pattern.hasMatch(endpoint));
  }

  Map<String, dynamic> _cleanQueryParameters(Map<String, dynamic>? parameters) {
    if (parameters == null) return {};

    // Create a new map without empty values
    return Map.from(parameters)
      ..removeWhere((key, value) {
        // Remove if value is null, empty string, or empty list/map
        return value == null ||
            (value is String && value.isEmpty) ||
            (value is Iterable && value.isEmpty) ||
            (value is Map && value.isEmpty);
      });
  }
}
