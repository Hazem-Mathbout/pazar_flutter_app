import 'package:dio/dio.dart';

String extractErrorMessage(dynamic error,
    {String fallback = 'حدث خطأ غير متوقع'}) {
  if (error is DioException) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      // Case 1: Direct message key
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }

      // ✅ Case 2: Nested error.message
      if (responseData['error'] is Map &&
          responseData['error']['message'] != null) {
        return responseData['error']['message'].toString();
      }
    }

    // Case 3: response is a plain string
    if (responseData is String) {
      return responseData;
    }
  }

  return fallback;
}
