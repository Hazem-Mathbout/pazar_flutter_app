import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/car_details/views/car_details_screen.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/cars/views/widgets/show_report_dialog.dart';

class CarCard extends StatelessWidget {
  final Advertisement advertisement;
  final AdvertisementController controller = Get.find();

  CarCard({required this.advertisement, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CarDetailsScreen(), arguments: {'carInfo': advertisement});
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Column(
            children: [
              // Image section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: advertisement.media.isNotEmpty
                        ? Image.network(
                            advertisement.media[0].url,
                            width: double.infinity,
                            height: 320,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${advertisement.viewsCount} مشاهدة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Info & Actions section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and price row
                    _buildTitleAndPrice(),

                    const SizedBox(height: 6),

                    // Make and it's model.
                    _buildMakeAndModel(),

                    const SizedBox(height: 6),

                    // Secondary info
                    _buildSecondaryInfo(context),

                    const SizedBox(height: 12),

                    // Actions row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<AdvertisementController>(
                          id: advertisement.id.toString(),
                          builder: (controller) => SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              // alignment: Alignment.centerRight,
                              icon: Icon(
                                advertisement.favoritedByAuth
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: advertisement.favoritedByAuth
                                    ? Colors.red
                                    : AppColors.foregroundSecondary,
                              ),
                              onPressed: () async => await controller
                                  .toggleFavorite(advertisement),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.report_gmailerrorred_outlined,
                              color: AppColors.foregroundSecondary,
                            ),
                            onPressed: () {
                              showReportDialog(context,
                                  (reason, description) async {
                                await controller.reportAdvertisement(
                                  advertisement,
                                  reason,
                                  description,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            advertisement.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${advertisement.price} \$',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildMakeAndModel() {
    final makeLabel = controller.makeString(advertisement.make.id);
    final modelLabel = advertisement.model.name;

    final fullLabel =
        modelLabel.trim().isNotEmpty ? '$makeLabel • $modelLabel' : makeLabel;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          const Icon(
            Icons.directions_car,
            size: 16,
            color: AppColors.foregroundSecondary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              fullLabel,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.foregroundPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryInfo(BuildContext context) {
    final fuel =
        advertisement.getFuelTypeLabel(advertisement.fuelType)?.ar ?? '__';
    final transmission = advertisement.metaLabels?.transmission?.ar ?? '__';
    final mileage = advertisement.metaLabels?.milage;
    final year = advertisement.metaLabels?.year;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _iconText(icon: Icons.calendar_today_outlined, label: '$year'),
        if (mileage != null) _iconText(icon: Icons.speed, label: '$mileage كم'),
        if (fuel.isNotEmpty)
          _iconText(icon: Icons.local_gas_station_outlined, label: fuel),
        if (transmission.isNotEmpty)
          _iconText(icon: Icons.settings, label: transmission),
      ],
    );
  }

  Widget _iconText({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.foregroundSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.foregroundPrimary,
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 320,
      color: AppColors.mediumGrey,
      child: const Center(
        child: Icon(
          Icons.directions_car,
          size: 48,
          color: AppColors.foregroundSecondary,
        ),
      ),
    );
  }
}
