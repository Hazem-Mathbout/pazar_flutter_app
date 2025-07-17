import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/car_details/controllers/car_details_controller.dart';
import 'package:pazar/app/modules/car_details/views/widgets/contact_bottom_bar.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/cars/views/widgets/show_report_dialog.dart';
import 'widgets/detail_table.dart';
import 'widgets/icon_text_pair.dart';
import 'widgets/image_carousel_viewer.dart';

class CarDetailsScreen extends StatelessWidget {
  CarDetailsScreen({super.key});
  final utilitiesService = Get.find<UtilitiesService>();
  final controller = Get.put(CarDetailsController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(() {
        final car = controller.carInfo.value;
        if (car == null) return const SizedBox();

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: ContactBottomBar(
            seller: car.seller,
            carInfo: car,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarouselViewer(
                  media: controller.carInfo.value!.media,
                  currentIndex: controller.currentIndex.value,
                  onIndexChanged: controller.updateImageIndex,
                ),
                _buildHeader(car),
                _buildDescription(car.description),
                _buildDetailSection("عن السيارة", controller.carDetails),
                _buildDetailSection("الميزات", controller.carFeatures),
                _buildDetailSection("عن الإعلان", controller.aboutAd),
                // _buildSimilarCars(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(Advertisement car) {
    final advertisementController = Get.find<AdvertisementController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, top: 8.0),
                    child: Text(
                      car.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, top: 8.0),
                    child: Text(
                      car.modelFullName.ar,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 24.0),
                  //   child: Text(
                  //     "موديل ${car.year}",
                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //       fontFamily: "Rubik",
                  //       color: AppColors.foregroundSecondary,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(
                      '${car.price} \$',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Rubik",
                        color: AppColors.foregroundPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GetBuilder<AdvertisementController>(
                    id: 'favorite',
                    builder: (controller) => _buildActionButton(
                      icon: car.favoritedByAuth
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: car.favoritedByAuth
                          ? Colors.red
                          : AppColors.foregroundSecondary,
                      onPressed: () async =>
                          await advertisementController.toggleFavorite(car),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    icon: Icons.share,
                    onPressed: () async {
                      // Add share functionality, we have [car.shareUrl]
                      await controller.shareCar(car.shareUrl ?? '');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    icon: Icons.report_gmailerrorred_outlined,
                    onPressed: () {
                      showReportDialog(
                        Get.context!,
                        (reason, description) async {
                          await advertisementController.reportAdvertisement(
                            car,
                            reason,
                            description,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        // Spec icons row (full width below)
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconTextPair(Icons.speed, car.mileage),
                IconTextPair(
                  Icons.local_gas_station,
                  car.getFuelTypeLabel(car.fuelType)!.ar,
                ),
                IconTextPair(Icons.settings, car.metaLabels!.transmission!.ar),
                IconTextPair(
                  Icons.directions_car,
                  utilitiesService.bodyTypes
                          .firstWhere((element) => element.key == car.bodyType)
                          .name
                          .ar ??
                      'غير محدد',
                ),
              ]
                  .map((widget) => Padding(
                      padding: const EdgeInsets.only(left: 8), child: widget))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, Map<String, dynamic> entries) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          DetailTable(
            tableName: title,
            entries: entries,
            rowSpacing: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'وصف السيارة',
            style: TextStyle(
              fontFamily: "Rubik", // Font family
              fontWeight: FontWeight.w500, // Matches font-weight: 500
              fontSize: 18, // Matches font-size: 18px
              height: 24 / 18, // Line-height conversion (24px / 18px)
              letterSpacing: 0, // Explicitly set to 0%
              textBaseline:
                  TextBaseline.alphabetic, // Ensures proper vertical alignment
            ),
            textAlign: TextAlign.right, // Align text to the right
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCars() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مثل هذه السيارة",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, fontFamily: "Rubik"),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          // SuggestionCars(),
          SizedBox(height: 48),
        ],
      ),
    );
  }

  // Extracted button widget for cleaner code
  Widget _buildActionButton({
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: color ?? AppColors.foregroundSecondary,
          size: 25,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
