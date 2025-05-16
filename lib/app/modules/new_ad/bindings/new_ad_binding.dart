import 'package:get/get.dart';

import '../controllers/new_ad_controller.dart';

class NewAdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewAdController>(
      () => NewAdController(),
    );
  }
}
