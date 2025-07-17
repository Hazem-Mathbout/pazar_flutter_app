import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/utilities_models.dart';
import 'package:share_plus/share_plus.dart';

class CarDetailsController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final Rx<Advertisement?> carInfo = Rx<Advertisement?>(null);
  final RxBool editCarDetails = false.obs;
  final utilitiesService = Get.find<UtilitiesService>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['carInfo'] is Advertisement) {
        carInfo.value = args['carInfo'];
      }
      editCarDetails.value = args['edit_car_details'] == true;
    }
  }

  void updateImageIndex(int index) {
    currentIndex.value = index;
  }

  void updateCarInfo(Advertisement newInfo) {
    carInfo.value = newInfo;
  }

  Map<String, dynamic> get carDetails {
    final car = carInfo.value;
    if (car == null) return {};
    print("car.make.id: ${car.make.id}");

    return {
      "المصنع": utilitiesService.makes
              .firstWhere(
                (element) => element.name == car.make.name,
                orElse: () => Make.empty(),
              )
              .label
              .ar ??
          'غير محدد',
      "الفئة": car.model.name ?? 'غير محدد',
      "الموديل": car.year.toString() ?? 'غير محدد',
      "نوع الجسم": utilitiesService.bodyTypes
              .firstWhere(
                (element) => element.key == car.bodyType,
                orElse: () => BodyType(
                    key: '',
                    name: LocalizedText(ar: 'غير محدد', en: 'unknown')),
              )
              .name
              .ar ??
          'غير محدد',
      "عدد المقاعد": car.seats?.toString() ?? "غير محدد",
      "عدد الأبواب": car.doors.toString() ?? "غير محدد",
      "الحالة": car.condition == 'new' ? 'جديد' : 'مستعمل',
      "المواصفات الإقليمية": utilitiesService.regionalSpecs
              .firstWhere(
                (element) => element.key == car.regionalSpecs,
                orElse: () => RegionalSpecs(
                    key: '',
                    label: LocalizedText(ar: 'غير محدد', en: 'unknown')),
              )
              .label
              .ar ??
          'غير محدد',
    };
  }

  Map<String, String> get carFeatures {
    final car = carInfo.value;
    if (car == null) return {};

    return {
      "نوع الوقود": car.getFuelTypeLabel(car.fuelType)?.ar ?? 'غير محدد',
      "نقل الحركة": car.metaLabels?.transmission?.ar ?? 'غير محدد',
      "لون الخارج": utilitiesService.exteriorColors
              .firstWhere(
                (element) => element.key == car.exteriorColor,
                orElse: () => ColorItem.empty(),
              )
              .name['ar'] ??
          'غير محدد',
      "لون الداخل": utilitiesService.interiorColors
              .firstWhere(
                (element) => element.key == car.interiorColor,
                orElse: () => ColorItem.empty(),
              )
              .name['ar'] ??
          'غير محدد',
    };
  }

  Map<String, String> get aboutAd {
    final ad = carInfo.value;
    if (ad == null) return {};
    return {
      "رقم الإعلان": ad.id.toString(),
      "الوضع الحالي": ad.status,
      "تاريخ النشر": DateFormat('yyyy-MM-dd').format(ad.createdAt),
      "العنوان الكامل": ad.address,
      "اسم البائع": ad.seller.name,
      "نوع الحساب":
          "${ad.seller.businessAccount ? "حساب تجاري" : "حساب شخصي"} ${ad.seller.verified ? "✅ موثق" : "❌ غير موثق"}",
    };
  }

  // Add this method to your class:
  Future<void> shareCar(String shareUrl) async {
    try {
      var param = ShareParams(
        subject: 'Car Listing on Pazarcom',
        text: 'Check out this car on Pazarcom: $shareUrl',
      );
      await SharePlus.instance.share(param);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not share: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
