import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final String info;
  final List<String> dropdownItems;

  const CustomMultiSelectDropdown({
    super.key,
    required this.info,
    required this.dropdownItems,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  List<String> selectedItems = []; // Track selected items

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info Text
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.info,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 16 / 14,
              letterSpacing: 0.0,
            ),
          ),
        ),

        // Input Field Container
        Container(
          // width: 352,
          // height: 48,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // Background color
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              // Open dropdown on tap
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: widget.dropdownItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          // Add item to selected list and close bottom sheet
                          if (!selectedItems.contains(item)) {
                            setState(() {
                              selectedItems.add(item);
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: Text(item),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                // Show selected items as chips inside the container
                Expanded(
                  child: Wrap(
                    spacing: 4.0, // Space between chips
                    runSpacing: 4.0, // Space between lines of chips
                    children: selectedItems
                        .map(
                          (item) => Container(
                            constraints: const BoxConstraints(
                              minHeight: 25,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8), // Set padding
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color for chip
                              borderRadius: BorderRadius.circular(
                                50,
                              ), // Border-radius to make it rounded
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    height: 16 / 12,
                                    letterSpacing: 0.0,
                                    color: AppColors.foregroundSecondary,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedItems.remove(
                                          item); // Remove item from selected list
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 16, // Set icon size
                                    color: AppColors
                                        .foregroundSecondary, // Icon color, adjust if needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // Dropdown Icon inside the same container
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Image.asset(
                    'assets/icons/selector.png',
                    height: 16,
                    width: 16,
                    color: AppColors.foregroundHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
