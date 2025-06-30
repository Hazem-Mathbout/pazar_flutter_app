import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/cars/views/widgets/filter_actions.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key});
  final controller = Get.find<AdvertisementController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus when tapped outside
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures it takes only the required height
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'الفلتر',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.foregroundPrimary,
                    ),
                  ),
                ),
              ),

              // Body Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ensures it takes only needed space
                  children: [
                    _buildFilterSection(
                      title: 'السعر',
                      minValueController: controller.minPriceController,
                      maxValueController: controller.maxPriceController,
                      onMinChanged: (val) => controller.filter.update((f) {
                        f?.minPrice = int.tryParse(val);
                      }),
                      onMaxChanged: (val) => controller.filter.update((f) {
                        f?.maxPrice = int.tryParse(val);
                      }),
                    ),
                    const SizedBox(height: 24),
                    _buildFilterSection(
                      title: 'السنة',
                      minValueController: controller.minYearController,
                      maxValueController: controller.maxYearController,
                      onMinChanged: (val) => controller.filter.update((f) {
                        f?.minYear = int.tryParse(val);
                      }),
                      onMaxChanged: (val) => controller.filter.update((f) {
                        f?.maxYear = int.tryParse(val);
                      }),
                    ),
                    const SizedBox(height: 24),
                    _buildFilterSection(
                      title: 'المسافة المقطوعة',
                      minValueController: controller.minMileageController,
                      maxValueController: controller.maxMileageController,
                      onMinChanged: (val) => controller.filter.update((f) {
                        f?.minMileage = int.tryParse(val);
                      }),
                      onMaxChanged: (val) => controller.filter.update((f) {
                        f?.maxMileage = int.tryParse(val);
                      }),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => _buildTransmissionFilterSection(
                        options: MetaLabelOptions.transmissions,
                        selected: controller.filter.value.transmission,
                        onSelect: (val) => controller.filter.update((f) {
                          if (f?.transmission == val) {
                            f?.transmission = null; // Toggle deselect
                          } else {
                            f?.transmission = val;
                          }
                        }),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FilterActions(
                      onApply: () {
                        // Possibly call API with controller.filter.value.toQueryParams()
                        print(controller.filter.value.toQueryParams());
                        controller.refreshData();
                        Get.back(); // Close the sheet
                      },
                      onReset: () {
                        controller.filter.update((f) => f?.reset());
                        controller.minPriceController.clear();
                        controller.maxPriceController.clear();
                        controller.minMileageController.clear();
                        controller.maxMileageController.clear();
                        controller.minYearController.clear();
                        controller.maxYearController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required TextEditingController? minValueController,
    required TextEditingController? maxValueController,
    required Function(String) onMinChanged,
    required Function(String) onMaxChanged,
  }) {
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
                child: _buildTextField('من', minValueController, onMinChanged)),
            const SizedBox(width: 12),
            Expanded(
                child:
                    _buildTextField('إلى', maxValueController, onMaxChanged)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label,
      TextEditingController? textFieldController, Function(String) onChanged) {
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
            controller: textFieldController,
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

  Widget _buildTransmissionFilterSection({
    required List<LocalizedText> options,
    required String? selected,
    required void Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع ناقل الحركة',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: Row(
            children: options.map((opt) {
              final isSelected = selected == opt.ar;

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
                  onSelected: (_) => onSelect(opt.ar),
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
  // Widget _buildFilterSection(String title) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(
  //           fontFamily: 'Rubik',
  //           fontWeight: FontWeight.w500,
  //           fontSize: 14,
  //           color: Colors.black,
  //         ),
  //       ),
  //       // const SizedBox(height: 8),
  //       SliderTheme(
  //         data: SliderThemeData(
  //           trackHeight: 8,
  //           inactiveTrackColor: Colors.black.withOpacity(0.12),
  //           activeTrackColor: const Color(0xFFE60023),
  //           thumbColor: Colors.white,
  //           overlayColor: Colors.black.withOpacity(0.06),
  //           thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
  //           overlayShape: SliderComponentShape.noThumb,
  //           trackShape: CustomTrackShape(),
  //         ),
  //         child: Slider(
  //           value: 50,
  //           min: 0,
  //           max: 100,
  //           onChanged: (value) {},
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(child: _buildTextField('من')),
  //           const SizedBox(width: 12),
  //           Expanded(child: _buildTextField('إلى')),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTextField(String label) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontFamily: 'Rubik',
  //           fontWeight: FontWeight.w400,
  //           fontSize: 14,
  //           color: Color(0xFF171717),
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 8),
  //         // height: 36,
  //         decoration: BoxDecoration(
  //           color: Colors.black.withOpacity(0.08),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: const TextField(
  //           // keyboardType: TextInputType.number,
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.symmetric(vertical: 10),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
