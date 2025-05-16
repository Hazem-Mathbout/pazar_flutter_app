import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/car_details/views/car_details_screen.dart';
import 'package:pazar/app/modules/my_ads/controllers/my_ads_controller.dart';
import 'package:pazar/app/shared/widgets/custom_action_bottom_sheet.dart';

class AdsListItem extends StatelessWidget {
  final Advertisement advertisement;
  AdsListItem({super.key, required this.advertisement});
  final myADController = Get.find<MyAdsController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CarDetailsScreen(),
          arguments: {
            'carInfo': advertisement,
            'edit_car_details': true,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: advertisement.media.isNotEmpty
                  ? Image.network(
                      advertisement.media[0].url,
                      width: 160,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 160,
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 160,
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image, // You can change this icon if needed
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Content Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Container
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<MyAdsController>(
                          builder: (controller) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9DCDC),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 14,
                                  color: AppColors.foregroundBrandDark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  myADController
                                      .mapStatusToArabic(advertisement.status),
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.foregroundBrandDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: PopupMenuButton<int>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 10.0,
                            position: PopupMenuPosition.under,
                            clipBehavior: Clip.hardEdge,
                            color: Colors.white,
                            offset: const Offset(0, 4),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                onTap: () {
                                  if (advertisement.status == 'pending') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'لا يمكنك تغيير حالة الإعلان الآن, لأنه قيد المراجعة.'),
                                      ),
                                    );
                                    return;
                                  }
                                  _showStatusChangeDialog(
                                      context, advertisement);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.album_outlined,
                                        color: Colors.black54),
                                    SizedBox(width: 8),
                                    Text(
                                      'تغيير حالة الإعلان',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: AppColors.foregroundPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                onTap: () async {
                                  await myADController
                                      .deleteAD(advertisement.id);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'حذف',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: AppColors.foregroundPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            icon: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white, // const Color(0xFF404040),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.more_vert,
                                size: 20,
                                color: Color(0xFF404040), // Color(0xFFF9DCDC),
                              ),
                            ),
                            onSelected: (value) {
                              // Add logic if needed
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      '${advertisement.make.name} . ${advertisement.model.name}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Details Row
                    Wrap(
                      spacing: 3,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildText(_mapTransmissionToArabic(
                            advertisement.transmission)),
                        _buildDot(),
                        _buildText('${advertisement.mileage} كم'),
                        _buildDot(),
                        _buildText(
                            _mapFuelTypeToArabic(advertisement.fuelType)),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price
                    Text(
                      '\$${advertisement.price}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF171717),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E5E5),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Rubik',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF404040),
      ),
    );
  }

  static String _mapTransmissionToArabic(String transmission) {
    switch (transmission.toLowerCase()) {
      case 'automatic':
        return 'أوتوماتيك';
      case 'manual':
        return 'عادي';
      default:
        return transmission;
    }
  }

  static String _mapFuelTypeToArabic(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case 'petrol':
        return 'بنزين';
      case 'diesel':
        return 'ديزل';
      case 'electric':
        return 'كهرباء';
      case 'hybrid':
        return 'هايبرد';
      default:
        return fuelType;
    }
  }

  void _showStatusChangeDialog(
      BuildContext context, Advertisement advertisement) {
    String selectedStatus = advertisement.status; // Current status as default

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تغيير حالة الإعلان'),
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['active', 'sold', 'unavailable'].map((status) {
                      return RadioListTile<String>(
                        title: Text(myADController.mapStatusToArabic(status)),
                        value: status,
                        groupValue: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  CustomActionBottomSheet(
                    padding: const EdgeInsets.all(0),
                    isSaveExpanded: true,
                    saveText: 'تغيير الحالة',
                    cancelText: 'إلغاء',
                    onCancel: () => Navigator.of(context).pop(),
                    onSave: () {
                      print("selectedStatus: $selectedStatus");
                      Navigator.of(context).pop();
                      myADController.updateAdStatus(
                        advertisement,
                        selectedStatus,
                      );
                    },
                  ),
                ],
              ),

              // actions: [
              //   TextButton(
              //     child: const Text('إلغاء'),
              //     onPressed: () => Navigator.of(context).pop(),
              //   ),
              //   ElevatedButton(
              //     child: const Text('تأكيد'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //       myADController.updateAdStatus(
              //         advertisement,
              //         selectedStatus,
              //       );
              //     },
              //   ),
              // ],
            );
          },
        );
      },
    );
  }
}
