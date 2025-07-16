// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pazar/app/core/values/colors.dart';
// import 'package:pazar/app/data/models/advertisement_model.dart';
// import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
// import 'package:pazar/app/modules/cars/views/widgets/filter_actions.dart';

// class FilterBottomSheet extends StatelessWidget {
//   FilterBottomSheet({super.key});
//   final controller = Get.find<AdvertisementController>();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus(); // Unfocus when tapped outside
//       },
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize:
//                 MainAxisSize.min, // Ensures it takes only the required height
//             children: [
//               // Header Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'الفلتر',
//                     style: TextStyle(
//                       fontFamily: 'Rubik',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                       color: AppColors.foregroundPrimary,
//                     ),
//                   ),
//                 ),
//               ),

//               // Body Section
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize:
//                       MainAxisSize.min, // Ensures it takes only needed space
//                   children: [
//                     _buildFilterSection(
//                       title: 'السعر',
//                       minValueController: controller.minPriceController,
//                       maxValueController: controller.maxPriceController,
//                       onMinChanged: (val) => controller.filter.update((f) {
//                         f?.minPrice = int.tryParse(val);
//                       }),
//                       onMaxChanged: (val) => controller.filter.update((f) {
//                         f?.maxPrice = int.tryParse(val);
//                       }),
//                     ),
//                     const SizedBox(height: 24),
//                     _buildFilterSection(
//                       title: 'السنة',
//                       minValueController: controller.minYearController,
//                       maxValueController: controller.maxYearController,
//                       onMinChanged: (val) => controller.filter.update((f) {
//                         f?.minYear = int.tryParse(val);
//                       }),
//                       onMaxChanged: (val) => controller.filter.update((f) {
//                         f?.maxYear = int.tryParse(val);
//                       }),
//                     ),
//                     const SizedBox(height: 24),
//                     _buildFilterSection(
//                       title: 'المسافة المقطوعة',
//                       minValueController: controller.minMileageController,
//                       maxValueController: controller.maxMileageController,
//                       onMinChanged: (val) => controller.filter.update((f) {
//                         f?.minMileage = int.tryParse(val);
//                       }),
//                       onMaxChanged: (val) => controller.filter.update((f) {
//                         f?.maxMileage = int.tryParse(val);
//                       }),
//                     ),
//                     const SizedBox(height: 24),
//                     Obx(
//                       () => _buildTransmissionFilterSection(
//                         options: MetaLabelOptions.transmissions,
//                         selected: controller.filter.value.transmission,
//                         onSelect: (val) => controller.filter.update((f) {
//                           if (f?.transmission == val) {
//                             f?.transmission = null; // Toggle deselect
//                           } else {
//                             f?.transmission = val;
//                           }
//                         }),
//                       ),
//                     ),
//                     const SizedBox(height: 50),
//                     FilterActions(
//                       onApply: () {
//                         // Possibly call API with controller.filter.value.toQueryParams()
//                         print(controller.filter.value.toQueryParams());
//                         controller.refreshData();
//                         Get.back(); // Close the sheet
//                       },
//                       onReset: () {
//                         controller.filter.update((f) => f?.reset());
//                         controller.minPriceController.clear();
//                         controller.maxPriceController.clear();
//                         controller.minMileageController.clear();
//                         controller.maxMileageController.clear();
//                         controller.minYearController.clear();
//                         controller.maxYearController.clear();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterSection({
//     required String title,
//     required TextEditingController? minValueController,
//     required TextEditingController? maxValueController,
//     required Function(String) onMinChanged,
//     required Function(String) onMaxChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontFamily: 'Rubik',
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//                 child: _buildTextField('من', minValueController, onMinChanged)),
//             const SizedBox(width: 12),
//             Expanded(
//                 child:
//                     _buildTextField('إلى', maxValueController, onMaxChanged)),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField(String label,
//       TextEditingController? textFieldController, Function(String) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontFamily: 'Rubik',
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//             color: Color(0xFF171717),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextField(
//             keyboardType: TextInputType.number,
//             controller: textFieldController,
//             onChanged: onChanged,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTransmissionFilterSection({
//     required List<LocalizedText> options,
//     required String? selected,
//     required void Function(String) onSelect,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'نوع ناقل الحركة',
//           style: TextStyle(
//             fontFamily: 'Rubik',
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 12),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.zero,
//           child: Row(
//             children: options.map((opt) {
//               final isSelected = selected == opt.ar;

//               return Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: FilterChip(
//                   label: Text(
//                     opt.ar,
//                     style: TextStyle(
//                       fontFamily: 'Rubik',
//                       fontSize: 16,
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   selected: isSelected,
//                   onSelected: (_) => onSelect(opt.ar),
//                   selectedColor: AppColors.foregroundPrimary,
//                   backgroundColor: Colors.black.withOpacity(0.08),
//                   checkmarkColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/cars/views/widgets/filter_actions.dart';
import 'package:pazar/app/shared/widgets/custom_radio_selection.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});
  final controller = Get.find<AdvertisementController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفلتر'),
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
      body: Padding(
        padding: const EdgeInsets.only(
            // bottom:
            //     MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price Range
                        RangeFilter(
                          title: 'السعر',
                          minController: controller.minPriceController,
                          maxController: controller.maxPriceController,
                          onMinChanged: (val) => controller.filter.update((f) {
                            f?.minPrice = int.tryParse(val);
                          }),
                          onMaxChanged: (val) => controller.filter.update((f) {
                            f?.maxPrice = int.tryParse(val);
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Year Range
                        RangeFilter(
                          title: 'السنة',
                          minController: controller.minYearController,
                          maxController: controller.maxYearController,
                          onMinChanged: (val) => controller.filter.update((f) {
                            f?.minYear = int.tryParse(val);
                          }),
                          onMaxChanged: (val) => controller.filter.update((f) {
                            f?.maxYear = int.tryParse(val);
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Mileage Range
                        RangeFilter(
                          title: 'المسافة المقطوعة',
                          minController: controller.minMileageController,
                          maxController: controller.maxMileageController,
                          onMinChanged: (val) => controller.filter.update((f) {
                            f?.minMileage = int.tryParse(val);
                          }),
                          onMaxChanged: (val) => controller.filter.update((f) {
                            f?.maxMileage = int.tryParse(val);
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Transmission
                        Obx(
                          () => ChipFilter(
                            title: 'نوع ناقل الحركة',
                            options: MetaLabelOptions.transmissions,
                            selectedValue: controller.filter.value.transmission,
                            onSelected: (val) => controller.filter.update((f) {
                              // var selectedChoice =
                              //     MetaLabelOptions.transmissions.firstWhere(
                              //   (element) => element.ar == val,
                              // );
                              // print("val: ${selectedChoice.en}");

                              f?.transmission =
                                  f.transmission == val ? null : val;
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Fuel Type (New)
                        Obx(
                          () => ChipFilter(
                            title: 'نوع الوقود',
                            options: MetaLabelOptions.fuelTypes,
                            selectedValue: controller.filter.value.fuelType,
                            onSelected: (val) => controller.filter.update((f) {
                              f?.fuelType = f.fuelType == val ? null : val;
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Make (New)
                        Obx(
                          () => CustomRadioSelection<String>(
                            info: 'الماركة',
                            items: MetaLabelOptions.makes
                                .map((e) => e.ar)
                                .toList(),
                            initialValue: controller.filter.value.make,
                            onChanged: (value) => controller.filter.update((f) {
                              f?.make = value == f.make
                                  ? null
                                  : value; // Toggle selection
                            }),
                            showDragHandle: false,
                            showClearButton: true,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Body Type (New)
                        Obx(
                          () => CustomRadioSelection<String>(
                            info: 'هيكل المركبة',
                            items: MetaLabelOptions.bodyTypes
                                .map((e) => e.ar)
                                .toList(),
                            initialValue: controller.filter.value.bodyType,
                            onChanged: (value) => controller.filter.update((f) {
                              f?.bodyType = value == f.bodyType
                                  ? null
                                  : value; // Toggle selection
                            }),
                            showDragHandle: false,
                            showClearButton: true,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Seats (New)
                        Obx(
                          () => CustomRadioSelection<int>(
                            info: 'عدد المقاعد',
                            items: MetaLabelOptions.seatOptions
                                .map((e) =>
                                    int.tryParse(e.ar
                                        .replaceAll(RegExp(r'[^0-9]'), '')) ??
                                    0)
                                .toList(),
                            itemAsString: (value) => value.toString(),
                            initialValue: controller.filter.value.seats,
                            onChanged: (value) => controller.filter.update((f) {
                              f?.seats = value;
                            }),
                            showDragHandle: false,
                            showClearButton: true,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Doors (New)
                        Obx(
                          () => CustomRadioSelection<int>(
                            info: 'عدد الأبواب',
                            items: MetaLabelOptions.doorOptions
                                .map((e) => int.tryParse(e.en) ?? 0)
                                .toList(),
                            itemAsString: (value) => value.toString(),
                            initialValue: controller.filter.value.doors,
                            onChanged: (value) => controller.filter.update((f) {
                              f?.doors = value;
                            }),
                            showDragHandle: false,
                            showClearButton: true,
                          ),
                        ),

                        // Makes (New)
                        // CustomRadioSelection<int>(
                        //   info: 'العلامة التجارية',
                        //   items: _utility.makes.map((make) => make.id).toList(),
                        //   itemAsString: (id) => _utility.makes
                        //       .firstWhere(
                        //         (make) => make.id == id,
                        //         orElse: () => Make(
                        //             id: 0,
                        //             name: LocalizedText(
                        //                 ar: 'غير معروف', en: 'Unknown')),
                        //       )
                        //       .name
                        //       .ar,
                        //   initialValue: controller.filter.value.makeId,
                        //   onChanged: (value) => controller.filter.update((f) {
                        //     f?.makeId = value;
                        //     f?.models = null; // Reset models when make changes
                        //   }),
                        //   showDragHandle: false,
                        // ),
                        const SizedBox(height: 24),

                        // Province (New)
                        Obx(
                          () => CustomRadioSelection<String>(
                            info: 'المحافظة',
                            items: MetaLabelOptions.provinces
                                .map((province) => province.ar)
                                .toList(),
                            initialValue: controller.filter.value.province,
                            onChanged: (value) => controller.filter.update((f) {
                              f?.province = value;
                            }),
                            showDragHandle: false,
                            showClearButton: true,
                          ),
                        ),
                        const SizedBox(height: 24),

                        FilterActions(
                          onApply: () {
                            controller.refreshData();
                            Get.back();
                          },
                          onReset: controller.resetFilters,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 16),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(16),
  //         topRight: Radius.circular(16),
  //       ),
  //     ),
  //     child: const Center(
  //       child: Text(
  //         'الفلتر',
  //         style: TextStyle(
  //           fontFamily: 'Rubik',
  //           fontWeight: FontWeight.w400,
  //           fontSize: 14,
  //           color: AppColors.foregroundPrimary,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// 1. Range Filter Widget (for price, year, mileage)
class RangeFilter extends StatelessWidget {
  final String title;
  final TextEditingController? minController;
  final TextEditingController? maxController;
  final ValueChanged<String> onMinChanged;
  final ValueChanged<String> onMaxChanged;

  const RangeFilter({
    super.key,
    required this.title,
    required this.minController,
    required this.maxController,
    required this.onMinChanged,
    required this.onMaxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _buildRangeField('من', minController, onMinChanged)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildRangeField('إلى', maxController, onMaxChanged)),
          ],
        ),
      ],
    );
  }

  Widget _buildRangeField(String label, TextEditingController? controller,
      ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF171717),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Chip Filter Widget (for transmission, etc.)
class ChipFilter extends StatelessWidget {
  final String title;
  final List<LocalizedText> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const ChipFilter({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((opt) {
              final isSelected = selectedValue == opt.ar;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilterChip(
                  label: Text(
                    opt.ar,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => onSelected(opt.ar),
                  selectedColor: AppColors.foregroundPrimary,
                  backgroundColor: Colors.black.withOpacity(0.08),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// 3. Selection Filter Widget (for long lists)
class SelectionFilter extends StatelessWidget {
  final String title;
  final List<LocalizedText> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onSelectionChanged;

  const SelectionFilter({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedValues.contains(option.ar);

              return CheckboxListTile(
                title: Text(
                  option.ar,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                  ),
                ),
                value: isSelected,
                onChanged: (selected) {
                  final newValues = List<String>.from(selectedValues);
                  if (selected == true) {
                    newValues.add(option.ar);
                  } else {
                    newValues.remove(option.ar);
                  }
                  onSelectionChanged(newValues);
                },
                activeColor: AppColors.foregroundPrimary,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

// New: Single Value Filter Widget (for seats, doors, province)
class SingleValueFilter extends StatelessWidget {
  final String title;
  final List<LocalizedText> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  const SingleValueFilter({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.08),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('الكل', style: TextStyle(fontFamily: 'Rubik')),
            ),
            ...options.map((option) => DropdownMenuItem(
                  value: option.ar,
                  child: Text(option.ar,
                      style: const TextStyle(fontFamily: 'Rubik')),
                )),
          ],
          onChanged: onSelected,
          isExpanded: true,
        ),
      ],
    );
  }
}
