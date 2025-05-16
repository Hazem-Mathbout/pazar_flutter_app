import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/modules/home/controllers/advertisement_controller.dart';
import 'package:pazar/app/routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // reactive index
  var isSearching = false.obs;
  TextEditingController searchFieldController = TextEditingController();
  // final dataLayer = Get.find<DataLayer>();

  // List of screens where we want to show the app bar
  final List<int> showAppBarForIndices = [0]; // Only show for Home (index 0)

  void onItemTapped(int index) {
    if (index == 2) {
      Get.toNamed(Routes.NEW_AD);
      return;
    }
    selectedIndex.value = index;
  }

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    if (searchFieldController.text.isNotEmpty) {
      searchFieldController.clear();
      final advertisementController = Get.find<AdvertisementController>();
      advertisementController.refreshData(newQuery: '');
    }
  }
}
