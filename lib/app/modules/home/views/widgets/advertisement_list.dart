import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/modules/home/controllers/advertisement_controller.dart';
import 'package:pazar/app/modules/home/views/widgets/car_card.dart';
import 'package:pazar/app/modules/home/views/widgets/car_card_skeleton.dart';
import '../../../../data/models/advertisement_model.dart';

class AdvertisementList extends StatelessWidget {
  final dvertisementController = Get.find<AdvertisementController>();

  AdvertisementList({super.key});

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: dvertisementController.pagingController,
      builder: (context, state, fetchNextPage) =>
          PagedSliverList<int, Advertisement>(
        state: state,
        fetchNextPage: fetchNextPage,
        // physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<Advertisement>(
          invisibleItemsThreshold: 3,
          itemBuilder: (context, item, index) => CarCard(advertisement: item),
          firstPageProgressIndicatorBuilder: (_) => FutureBuilder(
            future:
                Future.delayed(const Duration(minutes: 3)), // Simulate fetching
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Text(
                    'Check your internet connection',
                  ),
                ); // Fallback or empty state
              } else {
                return Column(
                  children: List.generate(3, (_) => const CarCardSkeleton()),
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
              const Center(child: Text("No advertisements found")),
          firstPageErrorIndicatorBuilder: (_) =>
              const Center(child: Text("Error loading advertisements")),
          newPageErrorIndicatorBuilder: (_) =>
              const Center(child: Text("Failed to load more")),
        ),
      ),
    );
  }
}
