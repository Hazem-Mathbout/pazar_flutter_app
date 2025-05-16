import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/auth/controllers/auth_controller.dart';
import 'package:pazar/app/modules/new_ad/views/new_ad_screen.dart';
import 'package:pazar/app/routes/app_pages.dart';

class ContactBottomBar extends StatelessWidget {
  final Seller seller;
  final Advertisement carInfo;
  // final bool showEditButton; // New parameter to show or hide the Edit button
  final authController = Get.find<AuthController>();

  ContactBottomBar({
    super.key,
    required this.seller,
    required this.carInfo,
    // this.showEditButton = false, // Default to false if not provided
  });

  @override
  Widget build(BuildContext context) {
    print(authController.userModel.value);
    // print(authController.userModel.value?.id);
    // print(seller.id);
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
                CircleAvatar(
                  radius: 28, // Half of the container height
                  backgroundImage: NetworkImage(seller.profileImageUrl ?? ''),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle image loading errors, e.g., show a placeholder
                    print('Error loading image: $exception');
                  },
                  backgroundColor: Colors.grey[200], // Placeholder color
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
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.black54, size: 24),
                        onPressed: () {
                          Get.toNamed(Routes.CONVERSATION, arguments: {
                            'seller': seller,
                            'carInfo': carInfo,
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // Phone Button
                      Container(
                        width: 56, // Diameter of the circle
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.red, // Red background
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.phone,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            // TODO: Implement phone call action later
                            print("Phone button tapped");
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
