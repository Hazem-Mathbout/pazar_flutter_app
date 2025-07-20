import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/my_ads/views/widgets/ads_list_item_skeleton.dart';
import 'package:pazar/app/shared/widgets/first_page_error_indicator.dart';
import '../controllers/my_ads_controller.dart';
import 'widgets/ads_list_item.dart';

class MyAdsScreen extends GetView<MyAdsController> {
  MyAdsScreen({super.key});
  // final List<Widget> items = [const AdsListItem(), const AdsListItem()];
  final MyAdsController myAdsController = Get.put(MyAdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اعلاناتي'), // Title from the image
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
        onRefresh: () async => controller.refreshData(),
        child: PagingListener(
          controller: controller.pagingController,
          builder: (context, state, fetchNextPage) =>
              PagedListView<int, Advertisement>(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(8.0),
            builderDelegate: PagedChildBuilderDelegate<Advertisement>(
              itemBuilder: (context, item, index) => AdsListItem(
                advertisement: item,
                index: index,
              ),
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
                          List.generate(3, (_) => const AdsListItemSkeleton()),
                    );
                  }
                },
              ),
              newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )),
              noItemsFoundIndicatorBuilder: (_) =>
                  const Center(child: Text("لا يوجد لديك اعلانات منشورة بعد!")),
              firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                isUnauthorized: controller.isUnauthorizedError,
                unauthorizedMessage: "يجب عليك تسجيل الدخول لعرض إعلاناتك!",
                genericErrorMessage: "حدث خطأ أثناء تحميل إعلاناتك.",
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
