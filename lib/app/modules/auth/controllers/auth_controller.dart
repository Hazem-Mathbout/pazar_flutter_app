import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/models/user_model.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/routes/app_pages.dart';
import 'package:pazar/app/shared/utils/error_handler.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final DataLayer _dataLayer = Get.find<DataLayer>();
  // Rx<UserModel>? userModel;
  Rxn<UserModel> userModel = Rxn<UserModel>();
  final utilitiesService = Get.find<UtilitiesService>();

  var isLogin = false.obs;

  // Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // clientId: '235888666003-ko31alab2pqvf884dki463b988n01cv6',
    serverClientId:
        '235888666003-icescb4nsrls2kbnpdufmnesgpom5akg.apps.googleusercontent.com',

    scopes: [
      'email',
      'profile',
      'openid',
      // 'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  void onInit() {
    super.onInit();
    _loadUserModel();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  Future<void> register() async {
    final name = fullNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final phone = phoneController.text;

    final cancelLoading = Toasts.showToastLoading();
    try {
      final response = await _dataLayer.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      if (response.statusCode == 200) {
        // Extract user data and token
        final userJson = response.data;
        final token = response.data['token'];

        // Set userModel and save to SharedPreferences
        userModel.value = UserModel.fromJson(userJson);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', userModel.value!.toRawJson());

        _dataLayer.setToken(token);

        Get.snackbar('تم', 'تم إنشاء الحساب بنجاح');
        Get.toNamed(Routes.OTPVERFICIATION);
      } else {
        Get.snackbar('خطأ', 'فشل في إنشاء الحساب');
      }
    } catch (e) {
      print("error: $e");
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تسجيل الدخول');
      Get.snackbar('خطأ', errorMessage);
    } finally {
      cancelLoading();
    }
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final cancelLoading = Toasts.showToastLoading();

    try {
      final response = await _dataLayer.post('/users/authenticate', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = response.data['token'];
        // final user = UserModel.fromJson(response.data);

        await prefs.setString('token', token);
        _dataLayer.setToken(token);

        var userInfo = await fetchUserInfo(response.data['id']);
        if (userInfo != null) {
          userModel.value = userInfo;
          await prefs.setString('user', userInfo.toRawJson());
        }

        Get.offAllNamed(Routes.CARS);
      } else {
        Get.snackbar('خطأ', 'فشل تسجيل الدخول');
      }
    } catch (e) {
      print("error: $e");
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تسجيل الدخول');
      Get.snackbar('خطأ', errorMessage);
    } finally {
      cancelLoading();
    }
  }

  Future<void> signInWithGoogle() async {
    final cancelLoading = Toasts.showToastLoading();

    try {
      final googleIdToken = await _getGoogleIdToken();
      log("googleIdToken: $googleIdToken");

      if (googleIdToken == null) {
        Get.snackbar('خطأ', "فشل تسجيل الدخول. الرجاء المحاولة مرة أخرى.");
        return;
      }

      final response = await _dataLayer.post('/users/authenticate', data: {
        "google_id_token": googleIdToken,
      });

      log("response Google: ${response.data}");
      log("statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = response.data['token'];

        await prefs.setString('token', token);
        _dataLayer.setToken(token);

        var userInfo = await fetchUserInfo(response.data['id']);
        if (userInfo != null) {
          userModel.value = userInfo;
          await prefs.setString('user', userInfo.toRawJson());
        }

        Get.offAllNamed(Routes.CARS);
      } else {
        Get.snackbar('خطأ', "فشل تسجيل الدخول. الرجاء المحاولة مرة أخرى.");
      }
    } catch (e) {
      log("error: $e");
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تسجيل الدخول');
      Get.snackbar('خطأ', errorMessage);
      rethrow;
    } finally {
      cancelLoading();
    }
  }

  Future<String?> _getGoogleIdToken() async {
    // Renamed method
    try {
      log("Starting _getGoogleIdToken");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      log("googleUser: $googleUser");
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      log("googleAuth: ${googleAuth.idToken}");

      // Get the ID token instead of access token
      return googleAuth.idToken; // This is the JWT token your backend needs
    } catch (error) {
      debugPrint("Google Sign-In Error: $error");
      return null;
    }
  }

  Future<UserModel?> fetchUserInfo(int id) async {
    final cancelLoading = Toasts.showToastLoading();
    try {
      final response = await _dataLayer.get('/auth');

      if (response.statusCode == 200) {
        // Set user model and save it to SharedPreferences
        userModel.value = UserModel(
          id: id,
          name: response.data['name'],
          email: response.data['email'],
          whatsappNumber: response.data['whatsapp_number'] ?? '',
          profileImageUrl: response.data['profile_image'],
        );
        return userModel.value;
      }
    } catch (e) {
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء جلب بياناتك');
      Get.snackbar('خطأ', errorMessage);
      rethrow;
    } finally {
      cancelLoading();
    }
    return null;
  }

  Future<void> updateAuthUser(UserModel updatedUser) async {
    final cancelLoading = Toasts.showToastLoading();

    try {
      final Map<String, dynamic> data = {
        'name': updatedUser.name.trim(),
        'email': updatedUser.email.trim(),
        'whatsapp_number': updatedUser.whatsappNumber.trim(),
      };

      if (updatedUser.profileImageUrl != null) {
        data['profile_image'] = await dio.MultipartFile.fromFile(
          updatedUser.profileImageUrl!.trim(),
        );
      }

      print("Updated data is: $data");

      final formData = dio.FormData.fromMap(data);
      final response =
          await _dataLayer.postFormData('/auth', formData: formData);

      if (response.statusCode == 200) {
        userModel.value = await fetchUserInfo(updatedUser.id) ?? updatedUser;
        print(
            "userModel?.profileImageUrl: ${userModel.value?.profileImageUrl}");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', userModel.value!.toRawJson());
        Get.snackbar('تم', 'تم تحديث بيانات المستخدم بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل تحديث بيانات المستخدم');
      }
    } catch (e) {
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تحديث البيانات');
      Get.snackbar('خطأ', errorMessage);
    } finally {
      cancelLoading();
    }
  }

  Future<void> updateUserPassword(
    String newPassword,
    String confirmNewPassword,
  ) async {
    final cancelLoading = Toasts.showToastLoading();
    try {
      final Map<String, dynamic> data = {
        'new_password': newPassword.trim(),
        'new_password_confirmation': confirmNewPassword.trim(),
      };
      final formData = dio.FormData.fromMap(data);
      final response =
          await _dataLayer.postFormData('/auth/password', formData: formData);

      if (response.statusCode == 200) {
        Get.snackbar('تم', 'تمّ تعيين كلمة المرور الجديدة بنجاح.');
      } else {
        Get.snackbar("خطأ", "فشل تعيين كلمة المرور الجديدة.");
      }
    } catch (e) {
      final errorMessage =
          extractErrorMessage(e, fallback: "فشل تعيين كلمة المرور الجديدة.");
      Get.snackbar('خطأ', errorMessage);
    } finally {
      cancelLoading();
    }
  }

  Future<void> logout() async {
    final cancelLoading = Toasts.showToastLoading();

    try {
      final prefs = Get.find<UtilitiesService>().prefs;
      final response = await _dataLayer.post('/auth/logout');

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('user');

        _dataLayer.setToken(null);
        userModel.value = null;

        // Get.offAllNamed(Routes.AUTH);
        Get.snackbar('تم', 'تم تسجيل الخروج بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل تسجيل الخروج');
      }
    } catch (e) {
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تسجيل الخروج');
      Get.snackbar('خطأ', errorMessage);
    } finally {
      cancelLoading();
    }
  }

  Future<void> _loadUserModel() async {
    final prefs = utilitiesService.prefs;
    String? rawUser = prefs.getString('user');
    String? userToken = prefs.getString('token');
    userModel.value = UserModel.fromRawJson(rawUser);
    _dataLayer.setToken(userToken);
    debugPrint(
        'user data is:\n${userModel.value.toString()}\ntoken: $userToken');
  }
}
