import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/car_details/controllers/car_details_controller.dart';
import 'package:pazar/app/modules/car_details/views/widgets/contact_bottom_bar.dart';
import 'package:pazar/app/modules/home/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/home/views/widgets/show_report_dialog.dart';
import 'widgets/detail_table.dart';
import 'widgets/icon_text_pair.dart';
import 'widgets/suggestion_cars.dart';

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
                _buildImageCarousel(controller),
                _buildHeader(car),
                _buildDescription(car.description),
                _buildDetailSection("عن السيارة", controller.carDetails),
                _buildDetailSection("الميزات", controller.carFeatures),
                _buildSimilarCars(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageCarousel(CarDetailsController controller) {
    final car = controller.carInfo.value!;
    final media = car.media;
    return Stack(
      children: [
        SizedBox(
          height: 294,
          child: ClipRRect(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 294,
                viewportFraction: 1,
                onPageChanged: (index, _) => controller.updateImageIndex(index),
              ),
              items: media.map((img) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                        image: NetworkImage(img.url), fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Obx(
            () => _buildImageIndicator(
                media.length, controller.currentIndex.value),
          ),
        ),
        Positioned(
          top: kToolbarHeight,
          right: 16,
          child: _buildBackButton(),
        ),
      ],
    );
  }

  Widget _buildImageIndicator(int total, int currentIndex) {
    return Container(
      constraints: const BoxConstraints(minWidth: 52), // optional
      height: 28,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0x7A000000),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          "${currentIndex + 1}/$total",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Rubik",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        width: 32,
        height: 32,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Transform.translate(
            offset: const Offset(-3, 0),
            child: const Icon(Icons.arrow_back_ios,
                color: AppColors.foregroundSecondary, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Advertisement car) {
    final advertisementController = Get.find<AdvertisementController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Car make and model
            Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 8.0),
              child: Text(
                car.model.name.isNotEmpty
                    ? "${controller.carDetails['المصنع']} - ${car.model.name}"
                    : controller.carDetails['المصنع'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Dropdown actions (favorite & report)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: [
                  Obx(() {
                    final isFavorite = advertisementController.isFavorite(car);
                    return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey
                            .shade200, // You can customize the background color
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : AppColors.foregroundSecondary,
                          size: 25,
                        ),
                        onPressed: () async =>
                            await advertisementController.toggleFavorite(car),
                      ),
                    );
                  }),
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.report_gmailerrorred_outlined,
                        color: AppColors.foregroundSecondary,
                        size: 25,
                      ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            "موديل ${car.year}",
            style: const TextStyle(
                fontSize: 16,
                fontFamily: "Rubik",
                color: AppColors.foregroundSecondary),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            '${car.price} \$',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: "Rubik",
                color: AppColors.foregroundPrimary),
          ),
        ),
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
                          .firstWhere(
                            (element) => element.key == car.bodyType,
                          )
                          .name['ar'] ??
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
}
