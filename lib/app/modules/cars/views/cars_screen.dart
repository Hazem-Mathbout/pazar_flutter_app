import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/colors.dart';
import '../controllers/advertisement_controller.dart';
import 'widgets/advertisement_list.dart';
import 'widgets/filter_sort_bar.dart';
import 'widgets/category_tabs.dart';
import '../controllers/home_controller.dart'; // <--- IMPORT CONTROLLER

class CarsScreen extends StatelessWidget {
  CarsScreen({super.key});

  final homeController = Get.put(HomeController());
  final AdvertisementController advertisementController =
      Get.put(AdvertisementController());
  final homeScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      RefreshIndicator(
        onRefresh: () async => advertisementController.refreshData(),
        child: CustomScrollView(
          controller: homeScrollController,
          slivers: [
            const SliverToBoxAdapter(child: FilterSortBar()),
            const SliverToBoxAdapter(child: CategoryTabs()),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              sliver: AdvertisementList(), // Make sure this returns a sliver
            ),
          ],
        ),
      ),
      // MyAdsScreen(),
      // const Center(child: Text("There is an error occure!")),
      // FavoritesScreen(),
      // MenuScreen(),
    ];
    return
        // Obx(
        //   () =>
        Scaffold(
      backgroundColor: AppColors.lightGrey,
      // appBar: homeController.showAppBarForIndices
      //         .contains(homeController.selectedIndex.value)
      //     ? homeController.isSearching.value
      //         ? _buildSearchAppBar(
      //             (p0) => advertisementController.search(p0),
      //           )
      //         : _buildDefaultAppBar()
      //     : null,
      body: SafeArea(
        child: Center(
          child: widgetOptions.elementAt(0),
        ),
      ),
    );
    // );
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      leading: IconButton(
        icon: Image.asset(
          'assets/icons/search.png',
          height: 24,
          width: 24,
          color: AppColors.foregroundSecondary,
        ),
        onPressed: () {
          Get.find<HomeController>().startSearch();
        },
      ),
      title: Image.asset(
        'assets/images/logo.png',
        height: 32,
        width: 32,
      ),
      centerTitle: true,
      actions: const [],
    );
  }

  PreferredSizeWidget _buildSearchAppBar(
      void Function(String) onSubmitCallback) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.close,
          color: AppColors.foregroundSecondary,
          size: 24,
        ),
        onPressed: () {
          Get.find<HomeController>().stopSearch();
        },
      ),
      titleSpacing: 0.0,
      title: TextField(
        autofocus: true,
        controller: homeController.searchFieldController,
        style: const TextStyle(color: Colors.black),
        cursorWidth: 1.0,
        cursorHeight: 24,
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          hintText: 'ما الذي تبحث عنه؟',
          hintStyle: TextStyle(
            color: AppColors.foregroundHint,
            fontSize: 14,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.0,
          ),
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitCallback, // Use the callback here
      ),
    );
  }
}
