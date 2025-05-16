import 'package:get/get.dart';

import '../controllers/conversation_controller.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(
      () => ConversationController(),
    );
    // Add any other dependencies needed for the Conversation module here
  }
}
