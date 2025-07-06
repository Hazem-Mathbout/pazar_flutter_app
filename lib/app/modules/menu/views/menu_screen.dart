import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/modules/cars/controllers/home_controller.dart';
import 'package:pazar/app/modules/menu/views/widgets/change_password_sheet.dart';
import 'package:pazar/app/routes/app_pages.dart';
import 'package:pazar/app/shared/utils/open_whatsapp_to_help.dart';
import 'widgets/edit_account_info_sheet.dart';
import 'widgets/setting_tail.dart';

class MenuScreen extends GetView<MenuController> {
  MenuScreen({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('القائمة'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.42857,
          letterSpacing: 0.0,
          color: Colors.black,
        ),
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE5E5E5), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF1D4B8),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5),
                              width: 1,
                            ),
                          ),
                          child: Obx(
                            () => ClipOval(
                              child: authController
                                          .userModel.value?.profileImageUrl !=
                                      null
                                  ? Image.network(
                                      authController
                                          .userModel.value!.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person,
                                            color: Colors.black54);
                                      },
                                    )
                                  : const Icon(Icons.person,
                                      color: Colors.black54),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Text(
                                    authController.userModel.value!.name,
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      letterSpacing: 0.0,
                                      color: Color(0xFF171717),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                authController.userModel.value!.email,
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 16 / 12,
                                  letterSpacing: 0.0,
                                  color: Color(0xFF737373),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Get.toNamed(Routes.NEW_AD),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 75),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0x14DC2626),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/car_icon.png',
                            width: 56,
                            height: 43,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'قم بعرض سيارتك للبيع الآن',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 20 / 14,
                              letterSpacing: 0.0,
                              color: AppColors.foregroundPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.foregroundDisabled,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: SettingsTile(
                      iconImage: 'assets/icons/user-circle.png',
                      title: 'إعدادات الحساب',
                      onTap: () => Get.to(
                            () => EditInfoSheet(
                              userModel: authController.userModel.value!,
                            ),
                          )
                      // showEditInfoSheet(
                      //   context,
                      //   authController.userModel.value!,
                      // ),
                      ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: SettingsTile(
                    iconImage: 'assets/icons/lock.png',
                    title: 'تعديل كلمة المرور',
                    onTap: () => Get.to(() => const EditPasswordInfoSheet()),
                    // showEditPasswordInfoSheet(context),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: SettingsTile(
                    iconImage: 'assets/icons/list-details.png',
                    title: 'اعلاناتي',
                    onTap: () {
                      final homeController = Get.find<HomeController>();
                      homeController.onItemTapped(1);
                    },
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: const SizedBox(height: 16),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: authController.userModel.value != null,
                  child: Container(
                    height: 1, // Border width
                    color: AppColors.borderDefault, // Border color
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // SettingsTile(
              //   iconImage: 'assets/icons/language.png',
              //   title: 'اللغة',
              //   onTap: () {
              //     print('Navigating to settings');
              //   },
              // ),
              SettingsTile(
                iconImage: 'assets/icons/brand-whatsapp.png',
                title: 'تواصل معنا',
                onTap: () => openWhatsApp(phoneNumber: ''),
              ),
              SettingsTile(
                iconImage: 'assets/icons/info-circle.png',
                title: 'عن بازار',
                onTap: () {
                  print('Navigating to settings');
                },
              ),
              SettingsTile(
                iconImage: 'assets/icons/list-check.png',
                title: 'الأحكام والشروط',
                onTap: () {
                  print('Navigating to settings');
                },
              ),
              Obx(
                () => SettingsTile(
                  iconImage: authController.userModel.value != null
                      ? 'assets/icons/logout.png'
                      : 'assets/icons/login.png',
                  title: authController.userModel.value != null
                      ? 'تسجيل الخروج'
                      : 'تسجيل دخول',
                  onTap: () async {
                    if (authController.userModel.value != null) {
                      await authController.logout();
                    } else {
                      Get.toNamed(Routes.AUTH);
                    }
                  },
                ),
              ),
              const SizedBox(height: 49),
            ],
          ),
        ),
      ),
    );
  }
}
