import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:name_avatar/name_avatar.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/modules/car_details/controllers/car_details_controller.dart';
import 'package:pazar/app/modules/new_ad/views/new_ad_screen.dart';
import 'package:pazar/app/shared/utils/open_whatsapp_to_help.dart';

class ContactBottomBar extends StatelessWidget {
  final Seller seller;
  final Advertisement carInfo;
  // final bool showEditButton; // New parameter to show or hide the Edit button
  final authController = Get.find<AuthController>();
  final carDetailsController = Get.find<CarDetailsController>();

  ContactBottomBar({
    super.key,
    required this.seller,
    required this.carInfo,
    // this.showEditButton = false, // Default to false if not provided
  });

  @override
  Widget build(BuildContext context) {
    final sellerName = seller.name;
    final profileImageUrl = seller.profileImageUrl;
    // print(authController.userModel.value?.id);
    // print(seller.profileImageUrl);
    // Using SafeArea to avoid intrusions like the home indicator
    return SafeArea(
      child: Container(
        height: 80, // Adjust height as needed
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.borderDefault, // Border color
              width: 1, // Border width
            ),
          ),
          // Optional: Rounded corners if desired, though the image looks sharp
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Right side: Seller Name and Avatar
            Row(
              children: [
                profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(profileImageUrl),
                        backgroundColor: Colors.grey[200],
                      )
                    : NameAvatar(
                        name: sellerName,
                        radius: 28,
                        isTwoChar: true,
                        // textStyle: const TextStyle(fontSize: 16),
                      ),
                const SizedBox(width: 12),
                Text(
                  seller.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            // Conditionally render either the Edit button or the Phone/Chat icons
            seller.id == authController.userModel.value?.id
                ? ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => NewAdScreen(
                          isEditMode: true,
                          advertisement: carInfo,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.backgroundBrand, // Background color
                      minimumSize: const Size(96, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Rounded button
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'تعديل',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      // Chat Button
                      // IconButton(
                      //   icon: const Icon(Icons.chat_bubble_outline,
                      //       color: Colors.black54, size: 24),
                      //   onPressed: () {
                      //     Get.toNamed(Routes.CONVERSATION, arguments: {
                      //       'seller': seller,
                      //       'carInfo': carInfo,
                      //     });
                      //   },
                      // ),
                      // const SizedBox(width: 8),
                      // Phone Button
                      Container(
                        width: 56, // Diameter of the circle
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.red, // Red background
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            openWhatsApp(
                              phoneNumber: seller.whatsappNumber,
                              message: 'مرحباً، أرغب في الاستفسار عن الإعلان.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
