import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
// import 'package:pazar/app/data/models/user_model.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/shared/widgets/custom_action_bottom_sheet.dart';
import 'package:pazar/app/shared/widgets/custom_input_filed.dart';

class EditPasswordInfoSheet extends StatefulWidget {
  const EditPasswordInfoSheet({super.key});

  @override
  State<EditPasswordInfoSheet> createState() => _EditInfoSheetState();
}

class _EditInfoSheetState extends State<EditPasswordInfoSheet> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // passwordController = TextEditingController(text: '***');
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final sheetWidth = screenWidth > 392 ? 392.0 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل كلمة المرور'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'إغلاق',
            onPressed: () => Get.back(),
            color: AppColors.foregroundSecondary,
          ),
        ],
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 24 / 18,
          color: Color(0xFF171717),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the border
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        // width: sheetWidth,
        // decoration: const BoxDecoration(
        //   color: Colors.white,
        //   // boxShadow: [
        //   //   BoxShadow(
        //   //     color: Color(0x29000000), // #00000029
        //   //     offset: Offset(0, 8),
        //   //     blurRadius: 16,
        //   //   ),
        //   //   BoxShadow(
        //   //     color: Color(0x14000000), // #00000014
        //   //     offset: Offset(0, 0),
        //   //     blurRadius: 4,
        //   //   ),
        //   // ],
        //   // borderRadius: BorderRadius.only(
        //   //   topRight: Radius.circular(16),
        //   //   topLeft: Radius.circular(16),
        //   // ),
        // ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ⬅️ Wrap height based on content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                //   decoration: const BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                //     ),
                //   ),
                //   width: double.infinity,
                //   child: const Text(
                //     'تعديل كلمة المرور',
                //     textAlign: TextAlign.right,
                //     style: TextStyle(
                //       fontFamily: 'Rubik',
                //       fontWeight: FontWeight.w500,
                //       fontSize: 18,
                //       height: 24 / 18,
                //       color: Color(0xFF171717),
                //     ),
                //   ),
                // ),

                // Body
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Apply padding only to the top content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputField(
                            info: 'كلمة المرور الجديدة',
                            isDropdown: false,
                            controller: passwordController,
                          ),
                          const SizedBox(height: 24),
                          CustomInputField(
                            info: 'تأكيد كلمة المرور الجديدة',
                            isDropdown: false,
                            controller: confirmPasswordController,
                          ),
                        ],
                      ),
                    ),

                    // Bottom sheet not inside the padding
                    CustomActionBottomSheet(
                      showBorder: true,
                      isSaveExpanded: false,
                      onCancel: () {
                        Get.back();
                      },
                      onSave: () async {
                        if (passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          Get.snackbar(
                            'خطأ',
                            'يجب إدخال الحقلين السابقيين',
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent,
                          );
                          return;
                        }
                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          Get.snackbar(
                            'خطأ',
                            'تأكيد كلمة المرور غير مطابقة لكلمة المرور.',
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent,
                          );
                          return;
                        }
                        final authController = Get.find<AuthController>();
                        await authController.updateUserPassword(
                          passwordController.text,
                          confirmPasswordController.text,
                        );
                        Get.close(0);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void showEditPasswordInfoSheet(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     barrierLabel: "Edit Info",
//     barrierDismissible: true,
//     barrierColor: Colors.black.withValues(alpha: 0.3),
//     transitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       final screenWidth = MediaQuery.of(context).size.width;
//       final sheetWidth = screenWidth > 392 ? 392.0 : screenWidth;

//       return Align(
//         alignment: Alignment.bottomRight, // ⬅️ Bottom + Right
//         child: Transform.translate(
//           offset: Offset(sheetWidth * (1 - animation.value), 0),
//           child: Material(
//             color: Colors.transparent,
//             child: GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: const EditPasswordInfoSheet(),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
