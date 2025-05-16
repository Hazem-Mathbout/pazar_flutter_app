import 'package:get/get.dart';

import '../controllers/chats_controller.dart';

class ChatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatsController>(
      () => ChatsController(),
    );
    // Add any other dependencies needed for the Chats module here
  }
}
