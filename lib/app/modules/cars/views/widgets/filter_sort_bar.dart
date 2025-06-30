import 'package:flutter/material.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';
import '../../../../core/values/colors.dart';
import 'filter_bottom_sheet.dart'; // Import colors - Corrected path

class FilterSortBar extends StatelessWidget {
  const FilterSortBar({super.key});

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: FilterBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
        top: 16,
      ),
      child: Row(
        children: [
          // 🔴 Filter Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showFilterBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  // Use RoundedRectangleBorder for custom radius
                  borderRadius:
                      BorderRadius.circular(16), // Set border radius to 16px
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(0, 40),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Prevent button from stretching
                mainAxisAlignment: MainAxisAlignment.center, // Center content
                children: [
                  const Text(
                    'الفلتر', // "Filter"
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      height: 1.43,
                      letterSpacing: 0.0,
                      color: Colors.white, // Keep existing color
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/icons/filter.png',
                    height: 16,
                    width: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 🔵 Sort Dropdown as a Button (Same style)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Open sorting options
                Toasts.showToastText('هذه الميزة سوف يتم تطبيقها مستقبلا');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Match dropdown color
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  // Use RoundedRectangleBorder for custom radius
                  borderRadius:
                      BorderRadius.circular(16), // Set border radius to 16px
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(0, 40),
                // side: BorderSide(color: AppColors.mediumGrey), // Border match
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Align center
                children: [
                  const Text(
                    'السعر: الاقل اولاً', // "Price: Lowest first"
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      height: 1.43,
                      letterSpacing: 0.0,
                      color:
                          AppColors.semiTransparentBlack, // Keep existing color
                    ),
                  ),
                  const SizedBox(width: 8), // Space between text and icon
                  Image.asset(
                    'assets/icons/chevron-down.png',
                    height: 16,
                    width: 16,
                    color: AppColors.foregroundSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
