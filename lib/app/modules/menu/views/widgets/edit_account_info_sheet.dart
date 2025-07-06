import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/user_model.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/shared/widgets/custom_action_bottom_sheet.dart';
import 'package:pazar/app/shared/widgets/custom_input_filed.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditInfoSheet extends StatefulWidget {
  final UserModel userModel;
  const EditInfoSheet({super.key, required this.userModel});

  @override
  State<EditInfoSheet> createState() => _EditInfoSheetState();
}

class _EditInfoSheetState extends State<EditInfoSheet> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  // late TextEditingController passwordController;
  late String? currentProfileImgUrl;
  File? newProfileImage;

  @override
  void initState() {
    print("User Info:\n${widget.userModel}");
    super.initState();
    nameController = TextEditingController(text: widget.userModel.name);
    emailController = TextEditingController(text: widget.userModel.email);
    phoneController =
        TextEditingController(text: widget.userModel.whatsappNumber);
    // passwordController = TextEditingController(text: '********');
    currentProfileImgUrl = widget.userModel.profileImageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sheetWidth = screenWidth > 392 ? 392.0 : screenWidth;
    print("currentProfileImgUrl: $currentProfileImgUrl");

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل المعلومات'),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ⬅️ Wrap height based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        const Text(
                          'الايميل',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 16 / 14,
                            color: Color(0xFF171717),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Avatar
                        AvatarWithEditIcon(
                          profileImageUrl: currentProfileImgUrl,
                          onImagePicked: (pickedImage) {
                            newProfileImage =
                                pickedImage; // You can define newProfileImage in parent
                          },
                        ),

                        const SizedBox(height: 24),
                        CustomInputField(
                          info: 'الأسم',
                          isDropdown: false,
                          controller: nameController,
                          initialValue: widget.userModel.name,
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          info: 'الإيميل',
                          isDropdown: false,
                          controller: emailController,
                          initialValue: widget.userModel.email,
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          info: 'رقم الجوال',
                          textInputType: TextInputType.phone,
                          isDropdown: false,
                          controller: phoneController,
                          initialValue: widget.userModel.whatsappNumber,
                        ),
                        // const SizedBox(height: 24),
                        // CustomInputField(
                        //   info: 'كلمة المرور',
                        //   isDropdown: false,
                        //   controller: passwordController,
                        // ),
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
                      final authController = Get.find<AuthController>();
                      UserModel user = UserModel(
                        id: widget.userModel.id,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        whatsappNumber: phoneController.text.trim(),
                        profileImageUrl: newProfileImage?.path,
                      );
                      await authController.updateAuthUser(user);
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
    );
  }
}

class AvatarWithEditIcon extends StatefulWidget {
  final String? profileImageUrl;
  final void Function(File image) onImagePicked;

  const AvatarWithEditIcon({
    super.key,
    required this.profileImageUrl,
    required this.onImagePicked,
  });

  @override
  State<AvatarWithEditIcon> createState() => _AvatarWithEditIconState();
}

class _AvatarWithEditIconState extends State<AvatarWithEditIcon> {
  File? newProfileImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() => newProfileImage = image);
      widget.onImagePicked(image); // callback to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = newProfileImage != null
        ? Image.file(newProfileImage!, fit: BoxFit.cover)
        : widget.profileImageUrl != null
            ? Image.network(widget.profileImageUrl!, fit: BoxFit.cover)
            : const Icon(Icons.person, size: 40, color: Colors.white);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1D4B8),
          ),
          child: ClipOval(child: imageWidget),
        ),
        Positioned(
          bottom: -4,
          left: -4,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// void showEditInfoSheet(BuildContext context, UserModel currentUserInfo) {
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
//               child: EditInfoSheet(userModel: currentUserInfo),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
