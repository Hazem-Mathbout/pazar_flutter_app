import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/shared/widgets/custom_input_filed.dart';
import 'package:pazar/app/shared/widgets/primary_button.dart';

class OtpVerficiationScreen extends StatelessWidget {
  OtpVerficiationScreen({super.key});
  final authController = Get.find<AuthController>();
  final textEditingControllerOTP = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
              iconSize: 20,
              onPressed: () {
                Get.back();
                // Navigator.pop(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDefault, // Background-Default
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Flexible(
                    child: Text(
                      "الرجاء إدخال رمز التحقق",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        height: 32 / 24,
                        letterSpacing: 0.0,
                        color: AppColors.foregroundPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Row(
                children: [
                  Flexible(
                    child: Text(
                      "لقد أرسلنا لك كوداً مكونًا من 4 أرقام إلى رقم الواتساب الخاص بك",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        letterSpacing: 0.0,
                        color: AppColors.foregroundSecondary,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24.0),
              CustomInputField(
                info: 'رمز التحقق',
                controller: textEditingControllerOTP,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'متابعة',
                  onPressed: () async {
                    await authController.verifyOTP(
                      textEditingControllerOTP.text.trim(),
                    );
                    // Get.offAllNamed(Routes.CARS);
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: authController.isSendingOTP.value
                          ? null
                          : () async {
                              await authController.sendOTP(
                                authController.phoneController.text,
                              );
                            },
                      child: authController.isSendingOTP.value
                          ? const SizedBox(
                              height: 35,
                              width: 35,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              "إعادة الإرسال",
                              style: TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: 0.0,
                                color: AppColors.foregroundBrand,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
