import 'package:get/get.dart';
import 'package:pazar/app/modules/my_ads/controllers/my_ads_controller.dart';

class MyAdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAdsController>(
      () => MyAdsController(),
    );
    // Add any other dependencies needed for the Chats module here
  }
}
