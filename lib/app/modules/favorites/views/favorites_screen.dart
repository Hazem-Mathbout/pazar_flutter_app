import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:pazar/app/modules/home/views/widgets/car_card.dart';
import 'package:pazar/app/modules/home/views/widgets/car_card_skeleton.dart';
import 'package:pazar/app/shared/widgets/first_page_error_indicator.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  // final List<Widget> items = [const AdsListItem(), const AdsListItem()];
  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'), // Title from the image
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height:
              1.42857, // 20px / 14px = 1.42857 (line-height in Flutter is a multiplier)
          letterSpacing: 0.0,
          color: Colors.black,
        ),
        centerTitle: false, // Center title as in the image
        elevation: 0.0, // Slight shadow like the image
        backgroundColor: Colors.white, // White background
        foregroundColor: Colors.black, // Black text/icons
      ),
      // Use ListView.builder to display the list of chats
      body: RefreshIndicator(
        onRefresh: () async => favoritesController.refreshData(),
        child: PagingListener(
          controller: favoritesController.pagingController,
          builder: (context, state, fetchNextPage) =>
              PagedListView<int, Advertisement>(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(8.0),
            builderDelegate: PagedChildBuilderDelegate<Advertisement>(
              itemBuilder: (context, item, index) =>
                  CarCard(advertisement: item),
              firstPageProgressIndicatorBuilder: (_) => FutureBuilder(
                future: Future.delayed(
                    const Duration(minutes: 3)), // Simulate fetching
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Center(
                      child: Text(
                        'Check your internet connection',
                      ),
                    ); // Fallback or empty state
                  } else {
                    return Column(
                      children:
                          List.generate(3, (_) => const CarCardSkeleton()),
                    );
                  }
                },
              ),
              newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )),
              noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text(
                'لم تقم بإضافة أي إعلانات إلى المفضلة بعد!',
              )),
              firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                isUnauthorized: favoritesController.isUnauthorizedError,
                unauthorizedMessage:
                    "يجب عليك تسجيل الدخول لعرض إعلانات المفضلة!",
                genericErrorMessage: "حدث خطأ أثناء تحميل إعلانات المفضلة.",
              ),
              newPageErrorIndicatorBuilder: (_) =>
                  const Center(child: Text("Failed to load more")),
            ),
          ),
        ),
      ),
    );
  }
}
