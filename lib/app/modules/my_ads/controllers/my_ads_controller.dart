import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';
import 'package:dio/dio.dart' as dio;

class MyAdsController extends GetxController {
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
          return null; // No more pages if the last page has less than the page size.
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
        '/auth/advertisements',
        queryParameters: {
          // 'page': pageKey.toString(),
          // 'query': searchTerm ?? '',
        },
      );

      // log("response.data: ${response.data}");
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
      // Check if error is unauthorized
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

  Future<void> deleteAD(int adID, int itemIndex) async {
    final cancelLoading = Toasts.showToastLoading();
    print("itemIndex: $itemIndex");
    print("pagingController.items: ${pagingController.items?.length}");

    try {
      final response = await _dataLayer.delete('/advertisements/$adID');

      if (response.statusCode == 200) {
        Get.snackbar(
          'تم الحذف',
          'تم حذف الإعلان بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        refreshData();
        // pagingController.items?.removeAt(itemIndex);
        // pagingController.notifyListeners();
      }
    } catch (e, stack) {
      log("error: $e , stack: $stack");
      Get.snackbar(
        'خطأ',
        'فشل حذف الإعلان',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      cancelLoading();
    }
  }

  void updateAdStatus(Advertisement ad, String newStatus) async {
    final cancelLoading = Toasts.showToastLoading();
    try {
      var formData = dio.FormData.fromMap({'new_status': newStatus});

      final response = await _dataLayer.postFormData(
        '/advertisements/${ad.id}/status',
        formData: formData,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'تم التحديث',
          'تم تغيير حالة الإعلان إلى ${mapStatusToArabic(newStatus)}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Update local state if needed
        ad.status = newStatus;
        update(); // if using GetX's controller
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في تغيير حالة الإعلان.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل تعديل حالة الإعلان',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      cancelLoading();
    }
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

  String mapStatusToArabic(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'نشط';
      case 'sold':
        return 'مباع';
      case 'pending':
        return 'قيد الانتظار';
      case 'unavailable':
        return 'غير متوفر';
      default:
        return status;
    }
  }
}
