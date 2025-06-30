import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/filter_model.dart';
import 'package:pazar/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';

import '../../../data/models/utilities_models.dart';

class AdvertisementController extends GetxController {
  String? _searchTerm;
  Rx<FilterModel> filter = FilterModel().obs;
  final DataLayer _dataLayer = Get.find<DataLayer>();
  static const int _pageSize = 20;
  int? itemsInLastPage;
  var utilityServices = Get.find<UtilitiesService>();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minYearController = TextEditingController();
  final maxYearController = TextEditingController();
  final minMileageController = TextEditingController();
  final maxMileageController = TextEditingController();

  /// This example uses a [PagingController] to manage the paging state.
  ///
  /// This is a robust inbuilt way to store your pagination state.
  /// The controller can also be used in multiple Paged layouts simultaneously,
  /// to share their state.
  late final pagingController = PagingController<int, Advertisement>(
    getNextPageKey: (state) {
      if (itemsInLastPage != null) {
        if (itemsInLastPage! < _pageSize) {
          return null;
        }
      }
      return (state.keys?.last ?? 0) + 1;
    },
    fetchPage: (pageKey) =>
        fetchNextPage(pageKey, searchTerm: _searchTerm, filter: filter.value),
  );

  Future<List<Advertisement>> fetchNextPage(int pageKey,
      {String? searchTerm, FilterModel? filter}) async {
    print("Fetching Next Page.....");
    print("searchTerm: $searchTerm");

    try {
      Map<String, String> baseParams = {
        'query': searchTerm ?? '',
        'page': pageKey.toString(),
      };

      final Map<String, String>? filterParams = filter?.toQueryParams();
      print("filter param: $filterParams");

      final response = await _dataLayer.get(
        '/advertisements',
        queryParameters: {
          ...baseParams,
          if (filterParams != null) ...filterParams, // Merging filter params
        },
      );

      if (response.statusCode == 200) {
        final List<Advertisement> newItems = List<Advertisement>.from(
          response.data['data'].map((e) => Advertisement.fromJson(e)),
        );

        print("newItems length: ${newItems.length}");
        itemsInLastPage = newItems.length;
        return newItems;
      }
      return [];
    } catch (e) {
      print("Error: $e");
      rethrow;
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

  void refreshData({String newQuery = ''}) {
    // if (pagingController.isLoading) return;
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

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<bool> backendFavoriteAd(int adID) async {
    try {
      final response = await _dataLayer.post(
        '/advertisements/$adID/favorite',
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error is: $e");
      return false;
    }
  }

  Future<bool> backendUnFavoriteAd(int adID) async {
    try {
      final response = await _dataLayer.post(
        '/advertisements/$adID/unfavorite',
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error is: $e");
      return false;
    }
  }

  // final RxList<int> _favoriteIds = <int>[].obs;

  // bool isFavorite(Advertisement ad) => _favoriteIds.contains(ad.id);
  bool isFavorite(Advertisement ad) => ad.favoritedByAuth;

  Future<void> toggleFavorite(Advertisement ad) async {
    final favController = Get.find<FavoritesController>();
    final wasFavorite = isFavorite(ad);

    // Optimistic update
    if (wasFavorite) {
      // _favoriteIds.remove(ad.id);
      ad.favoritedByAuth = false;
    } else {
      // _favoriteIds.add(ad.id);
      ad.favoritedByAuth = true;
    }
    update([ad.id.toString()]);

    // Call correct backend method
    final isDone = wasFavorite
        ? await backendUnFavoriteAd(ad.id)
        : await backendFavoriteAd(ad.id);

    if (isDone) {
      // _updateLocalFavorites(ad.id, !wasFavorite);

      final oldPages = favController.pagingController.pages ?? [];
      final newPages = List<List<Advertisement>>.from(
        oldPages.map((page) => List<Advertisement>.from(page)),
      );

      // Update logic:
      if (!wasFavorite) {
        // Insert the ad at the top of the first page
        if (newPages.isNotEmpty) {
          newPages[0].insert(0, ad);
        } else {
          newPages.add([ad]);
        }
      } else {
        // Remove the ad from any page that contains it
        for (final page in newPages) {
          page.removeWhere((item) => item.id == ad.id);
        }
        // Also remove any empty pages to keep alignment clean
        newPages.removeWhere((page) => page.isEmpty);
      }

      // Recalculate keys based on your paging logic
      final newKeys = List.generate(newPages.length, (index) => index + 1);

      // Update the controller state
      favController.pagingController.value = PagingState(
        pages: newPages,
        keys: newKeys,
        hasNextPage: favController.pagingController.hasNextPage,
      );

      Toasts.showToastText(wasFavorite
          ? 'تمت إزالة الإعلان من المفضلة.'
          : 'تمّ حفظ الإعلان في المفضلة.');
    } else {
      // Revert optimistic update
      if (wasFavorite) {
        // _favoriteIds.add(ad.id);
        ad.favoritedByAuth = true;
      } else {
        // _favoriteIds.remove(ad.id);
        ad.favoritedByAuth = false;
      }

      Get.snackbar(
        'خطأ',
        'فشل حفظ الإعلان في المفضلة.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update(['favorite']);
  }

  // void _updateLocalFavorites(int adId, bool add) {
  //   final prefs = utilityServices.prefs;
  //   final prefsFavoriteIds = prefs.getStringList('favoriteIds') ?? [];

  //   final adIdStr = adId.toString();
  //   if (add) {
  //     if (!prefsFavoriteIds.contains(adIdStr)) {
  //       prefsFavoriteIds.add(adIdStr);
  //     }
  //   } else {
  //     prefsFavoriteIds.remove(adIdStr);
  //   }

  //   prefs.setStringList('favoriteIds', prefsFavoriteIds);
  // }

  @override
  void onInit() {
    pagingController.addListener(_showError);
    // var prefs = utilityServices.prefs;
    // List<String> stringIds = prefs.getStringList('favoriteIds') ?? [];
    // List<int> favoriteIds = stringIds
    //     .where((id) => int.tryParse(id) != null)
    //     .map((id) => int.parse(id))
    //     .toList();
    // _favoriteIds.value = favoriteIds;

    super.onInit();
  }

  Future<void> reportAdvertisement(Advertisement ad, String reason,
      [String? description]) async {
    final cancelLoading = Toasts.showToastLoading();
    try {
      final response = await _dataLayer.post(
        '/advertisements/${ad.id}/report',
        data: {
          'reason': reason,
          if (description != null && description.trim().isNotEmpty)
            'description': description.trim(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'تم إرسال التبليغ',
          'شكرًا لملاحظتك، سيتم مراجعة الإعلان.',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      } else {
        _showErrorSnackbar();
      }
    } catch (e) {
      print('Report error: $e');
      _showErrorSnackbar();
    } finally {
      cancelLoading();
    }
  }

  void _showErrorSnackbar() {
    Get.snackbar(
      'فشل في إرسال التبليغ',
      'حدث خطأ أثناء إرسال التبليغ، حاول مرة أخرى.',
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  String makeString(int makeId) {
    final make = utilityServices.makes.firstWhere(
      (element) => element.id == makeId,
      orElse: () => Make.empty(),
    );
    return make.label['ar'] ?? 'غير معروف';
  }
}
