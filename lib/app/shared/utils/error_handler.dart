import 'package:dio/dio.dart';

String extractErrorMessage(
  dynamic error, {
  String fallback = 'حدث خطأ غير متوقع',
}) {
  try {
    if (error is DioException) {
      final responseData = error.response?.data;

      // Handle HTML responses (like 404 Not Found pages)
      if (responseData is String &&
          responseData.trim().startsWith('<!DOCTYPE html>')) {
        return _getStatusMessage(error.response?.statusCode) ?? fallback;
      }

      // Handle Map responses
      if (responseData is Map) {
        // Case 1: Direct message key
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }

        // Case 2: Nested error.message
        if (responseData['error'] is Map &&
            responseData['error']['message'] != null) {
          return responseData['error']['message'].toString();
        }

        // Case 3: Check for other common error message formats
        if (responseData['error'] != null) {
          return responseData['error'].toString();
        }
      }

      // Case 4: response is a plain string
      if (responseData is String) {
        return responseData;
      }

      // Case 5: Use DioException's message if available
      if (error.message != null) {
        return error.message!;
      }

      // Case 6: Fallback to status message
      return _getStatusMessage(error.response?.statusCode) ?? fallback;
    }

    // Handle non-Dio errors
    if (error is Error) {
      return error.toString();
    }

    if (error is String) {
      return error;
    }
  } catch (e) {
    // If anything goes wrong in extraction, return fallback
    print('Error extracting error message: $e');
  }

  return fallback;
}

String? _getStatusMessage(int? statusCode) {
  if (statusCode == null) return null;

  final messages = {
    400: 'طلب غير صالح',
    401: 'غير مصرح به',
    403: 'ممنوع',
    404: 'لم يتم العثور على الصفحة',
    500: 'خطأ داخلي في الخادم',
    502: 'بوابة خاطئة',
    503: 'الخدمة غير متوفرة',
    504: 'انتهت مهلة البوابة',
  };

  return messages[statusCode];
}
