import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/shared/widgets/custom_input_filed.dart';
import 'package:pazar/app/shared/widgets/primary_button.dart';
import 'package:pazar/app/shared/widgets/social_button.dart';

import '../controllers/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const SizedBox.shrink(),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.close),
        //   tooltip: 'إغلاق',
        // ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 12, left: 4, bottom: 12),
            padding: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'إغلاق',
              iconSize: 20,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close),
              color: AppColors.foregroundSecondary,
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            final isLogin = authController.isLogin.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "مرحباً بكم في بازار",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        height: 32 / 24,
                        letterSpacing: 0.0,
                        color: AppColors.foregroundPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// Social Buttons
                SocialButton(
                  text: 'جوجل',
                  iconPath: 'assets/images/google.png',
                  onPressed: () async {
                    await authController.signInWithGoogle();
                  },
                ),
                const SizedBox(height: 8),
                SocialButton(
                  text: 'فيسبوك',
                  iconPath: 'assets/images/facebook.png',
                  onPressed: () {},
                ),
                const SizedBox(height: 24),

                if (!isLogin) ...[
                  CustomInputField(
                    info: 'الاسم الكامل',
                    controller: authController.fullNameController,
                  ),
                  const SizedBox(height: 24),
                ],

                CustomInputField(
                  info: 'البريد الإلكتروني',
                  controller: authController.emailController,
                ),
                const SizedBox(height: 24),
                CustomInputField(
                  info: 'كلمة المرور',
                  controller: authController.passwordController,
                  // isPassword: true,
                ),
                const SizedBox(height: 24),

                if (!isLogin) ...[
                  CustomInputField(
                    info: 'رقم الجوال',
                    controller: authController.phoneController,
                  ),
                ],
                const SizedBox(height: 8),

                if (isLogin)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.0,
                        color: AppColors.foregroundBrand,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                /// Primary Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                    onPressed: () {
                      isLogin
                          ? authController.login()
                          : authController.register();
                    },
                  ),
                ),
                const SizedBox(height: 24),

                /// Toggle Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? 'ليس لديك حساب بعد؟' : 'هل لديك حساب بالفعل؟',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0.0,
                        color: AppColors.foregroundHint,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: authController.toggleAuthMode,
                      child: Text(
                        isLogin ? 'إنشاء حساب' : 'تسجيل الدخول',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 0.0,
                          color: AppColors.foregroundBrand,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
