import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';

class FavoritesController extends GetxController {
  final DataLayer _dataLayer = Get.find<DataLayer>();
  static const int _pageSize = 20;
  int? itemsInLastPage;

  String? _searchTerm;
  bool isUnauthorizedError = false;

  /// This example uses a [PagingController] to manage the paging state.
  late final pagingController = PagingController<int, Advertisement>(
    getNextPageKey: (state) {
      if (itemsInLastPage != null) {
        if (itemsInLastPage! < _pageSize) {
          return null; // No more pages if the last page has fewer items than the page size.
        }
      }
      return (state.keys?.last ?? 0) + 1;
    },
    fetchPage: (pageKey) => fetchNextPage(pageKey, searchTerm: _searchTerm),
  );

  Future<List<Advertisement>> fetchNextPage(int pageKey,
      {String? searchTerm}) async {
    print("Fetching Next Page.....");

    try {
      final response = await _dataLayer.get(
        '/auth/favorites', // Endpoint for favorites
        queryParameters: {
          'page': pageKey.toString(),
          'query': searchTerm ?? '', // Use searchTerm if available
        },
      );

      if (response.statusCode == 200) {
        final List<Advertisement> newItems = List<Advertisement>.from(
          response.data['data'].map((e) => Advertisement.fromJson(e)),
        );

        itemsInLastPage = newItems.length;
        print("newItems length: ${newItems.length}");
        return newItems;
      }
      return [];
    } catch (e) {
      print("Error: $e");
      if (e.toString().contains('Unauthorized')) {
        isUnauthorizedError = true;
      }
      rethrow;
    }
  }

  void refreshData({String newQuery = ''}) {
    isUnauthorizedError = false;
    _searchTerm = newQuery;
    itemsInLastPage = null;
    pagingController.refresh();
  }

  /// This method listens to notifications from the [_pagingController] and
  /// shows a [SnackBar] when an error occurs.
  Future<void> _showError() async {
    if (pagingController.value.status == PagingStatus.subsequentPageError) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Text(
            'Something went wrong while fetching a new page.',
          ),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => pagingController.fetchNextPage(),
          ),
        ),
      );
    }
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      return;
    }
    _searchTerm = query;
    itemsInLastPage = null;
    pagingController.refresh();
  }

  void updateFavoritesList(Advertisement ad) {
    update();
  }

  @override
  void onInit() {
    pagingController.addListener(_showError);
    super.onInit();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
