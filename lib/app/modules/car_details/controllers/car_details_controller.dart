import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/utilities_models.dart';

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
    // print(car.make.name);
    return {
      // "المصنع" : car.make.name
      "المصنع": utilitiesService.makes
              .firstWhere(
                (element) => element.name == car.make.name,
                orElse: () => Make.empty(),
              )
              .label['ar'] ??
          'غير محدد',
      "الفئة": car.model.name,
      "الموديل": car.year.toString(),
      "نوع الجسم": utilitiesService.bodyTypes
              .firstWhere(
                (element) => element.key == car.bodyType,
              )
              .name['ar'] ??
          'غير محدد',
      "عدد المقاعد": car.seats?.toString() ?? "غير محدد",
      "عدد الأبواب": car.doors,
      "الحالة": car.condition == 'new' ? 'جديد' : 'مستعمل',
    };
  }

  Map<String, String> get carFeatures {
    final car = carInfo.value;
    if (car == null) return {};
    return {
      "نوع الوقود": car.getFuelTypeLabel(car.fuelType)!.ar,
      "نقل الحركة": car.metaLabels!.transmission!.ar,
      "لون الخارج": utilitiesService.exteriorColors
              .firstWhere(
                (element) => element.key == car.exteriorColor,
              )
              .name['ar'] ??
          'غير محدد',
      "لون الداخل": utilitiesService.interiorColors
              .firstWhere(
                (element) => element.key == car.interiorColor,
              )
              .name['ar'] ??
          'غير محدد',
      "العنوان": car.metaLabels!.location!.ar,
      "الحالة": car.status,
      // "المشاهدات": car.viewsCount.toString(),
    };
  }
}
