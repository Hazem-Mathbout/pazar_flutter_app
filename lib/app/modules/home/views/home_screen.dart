import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/modules/cars/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/cars/controllers/home_controller.dart';
import 'package:pazar/app/modules/cars/views/widgets/advertisement_list.dart';
import 'package:pazar/app/modules/cars/views/widgets/category_tabs.dart';
import 'package:pazar/app/modules/cars/views/widgets/filter_sort_bar.dart';
import 'package:pazar/app/modules/favorites/views/favorites_screen.dart';
import 'package:pazar/app/modules/home/views/widgets/home_widget.dart';
import 'package:pazar/app/modules/menu/views/menu_screen.dart';
import 'package:pazar/app/modules/my_ads/views/my_ads_screen.dart';
import '../../../core/values/colors.dart';

// New design for the home screen will be used in the later versions d\
// from the app.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());
  final AdvertisementController advertisementController =
      Get.put(AdvertisementController());
  final homeScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeWidget(),
      // RefreshIndicator(
      //   onRefresh: () async => advertisementController.refreshData(),
      //   child: CustomScrollView(
      //     controller: homeScrollController,
      //     slivers: [
      //       const SliverToBoxAdapter(child: FilterSortBar()),
      //       const SliverToBoxAdapter(child: CategoryTabs()),
      //       SliverPadding(
      //         padding:
      //             const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      //         sliver: AdvertisementList(), // Make sure this returns a sliver
      //       ),
      //     ],
      //   ),
      // ),
      MyAdsScreen(),
      const Center(child: Text("There is an error occure!")),
      FavoritesScreen(),
      MenuScreen(),
    ];
    return Obx(() => Scaffold(
          backgroundColor: AppColors.lightGrey,
          // appBar: homeController.showAppBarForIndices
          //         .contains(homeController.selectedIndex.value)
          //     ? homeController.isSearching.value
          //         ? _buildSearchAppBar(
          //             (p0) => advertisementController.search(p0),
          //           )
          //         : _buildDefaultAppBar()
          //     : null,
          body: Center(
            child: widgetOptions.elementAt(homeController.selectedIndex.value),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.black,
              letterSpacing: 0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
              color: Colors.black,
              letterSpacing: 0,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/home.png',
                  height: 20,
                  width: 20,
                  color: AppColors.foregroundHint,
                ),
                activeIcon: Image.asset(
                  'assets/icons/home.png',
                  height: 20,
                  width: 20,
                  color: AppColors.textBrand,
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/my_ads.png',
                  height: 20,
                  width: 20,
                  color: AppColors.foregroundHint,
                ),
                activeIcon: Image.asset(
                  'assets/icons/my_ads.png',
                  height: 20,
                  width: 20,
                  color: AppColors.textBrand,
                ),
                label: 'اعلاناتي',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/add_ads.png',
                  height: 20,
                  width: 20,
                  color: AppColors.foregroundHint,
                ),
                activeIcon: Image.asset(
                  'assets/icons/add_ads.png',
                  height: 20,
                  width: 20,
                  color: AppColors.textBrand,
                ),
                label: 'اعلان جديد',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/heart.png',
                  height: 20,
                  width: 20,
                  color: AppColors.foregroundHint,
                ),
                activeIcon: Image.asset(
                  'assets/icons/heart.png',
                  height: 20,
                  width: 20,
                  color: AppColors.textBrand,
                ),
                label: 'المفضلة',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/menue.png',
                  height: 20,
                  width: 20,
                  color: AppColors.foregroundHint,
                ),
                activeIcon: Image.asset(
                  'assets/icons/menue.png',
                  height: 20,
                  width: 20,
                  color: AppColors.textBrand,
                ),
                label: 'القائمة',
              ),
            ],
            currentIndex: homeController.selectedIndex.value,
            selectedItemColor: AppColors.primaryRed,
            unselectedItemColor: AppColors.darkGrey,
            onTap: homeController.onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 5.0,
            showUnselectedLabels: true,
          ),
        ));
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
      actions: const [
        // IconButton(
        //   icon: Image.asset(
        //     'assets/icons/bell.png',
        //     height: 24,
        //     width: 24,
        //     color: AppColors.foregroundSecondary,
        //   ),
        //   onPressed: () {
        //     // handle notification
        //   },
        // ),
      ],
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
