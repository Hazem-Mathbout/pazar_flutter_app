import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import '../../../../core/values/colors.dart'; // Import colors

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int _selectedSegment = 0; // 0 = All, 1 = Used, 2 = New
  final List<String> _segmentLabels = const ['الكل', 'المستعمل', 'الجديد'];
  final advertisementController = Get.find<AdvertisementController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 8.0,
        left: 8.0,
        top: 0,
        bottom: 0.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white, // Set background to white
        borderRadius: BorderRadius.circular(16.0), // Outer border radius
        // Removed border
      ),
      clipBehavior:
          Clip.antiAlias, // Clip inner content to the outer border radius
      child: Padding(
        // Add padding around the Row
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: List.generate(_segmentLabels.length, (index) {
            final bool isSelected = _selectedSegment == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSegment = index;
                  });
                  // TODO: Add logic to filter based on selection
                  String? condition;
                  switch (_selectedSegment) {
                    case 0:
                      condition = null;
                      break;
                    case 1:
                      condition = 'used';
                      break;
                    case 2:
                      condition = 'new';
                      break;
                    default:
                      condition = null;
                  }
                  advertisementController.filter.update((f) {
                    f?.condition = condition;
                  });
                  advertisementController.refreshData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ), // Padding inside each segment
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEFEFEF)
                        : Colors.transparent, // Selected background color
                    borderRadius: BorderRadius.circular(
                        14.0), // Inner segment border radius
                  ),
                  child: Center(
                    // Center the text
                    child: Text(
                      _segmentLabels[index],
                      textAlign: TextAlign.center, // Ensure text alignment
                      style: const TextStyle(
                        fontFamily: 'Rubik', // Apply Rubik font
                        fontWeight:
                            FontWeight.w400, // Set weight to 400 (normal)
                        fontSize: 14.0, // Set font size
                        height: 1.43, // Set line height (20 / 14)
                        letterSpacing: 0.0, // Set letter spacing
                        color: AppColors
                            .semiTransparentBlack, // Keep existing color
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
