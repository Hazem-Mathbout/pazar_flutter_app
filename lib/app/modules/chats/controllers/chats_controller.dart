import 'package:get/get.dart';

class ChatsController extends GetxController {
  //TODO: Implement ChatsController

  final count = 0.obs; // Example observable
  @override
  void onInit() {
    super.onInit();
    // Initialize chat list loading or other setup
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++; // Example method
}
