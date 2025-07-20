// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/new_ad/controllers/new_ad_controller.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';

class EditAdImagesController extends GetxController {
  RxList<File> imageFiles = <File>[].obs;
  RxList<ImageMedia> imageMedia = <ImageMedia>[].obs;
  bool useLocalFiles = true;

  EditAdImagesController();

  final addController = Get.find<NewAdController>();

  initImages(List<File> imageFiles, List<ImageMedia> imageMedia) {
    this.imageFiles.value = imageFiles.map((e) => e).toList();
    this.imageMedia.value = imageMedia.map((e) => e).toList();
  }

  // DataLayer instance to handle requests
  final DataLayer _dataLayer = Get.find<DataLayer>();

  void setImages({List<File>? localFiles, List<ImageMedia>? urls}) {
    if (useLocalFiles) {
      imageFiles.assignAll(localFiles ?? []);
    } else {
      imageMedia.assignAll(urls ?? []);
    }
    update(['images_preview']);
  }

  void deleteImageAt(int index) {
    if (useLocalFiles) {
      imageFiles.removeAt(index);
    } else {
      imageMedia.removeAt(index);
    }
    update(['images_preview']);
  }

  void saveFinalImagesEdit() {
    if (imageFiles.length + imageMedia.length <= 0) {
      throw "يجب ان يكون للإعلان صورة واحدة على الأقل!";
    }

    addController.imageFiles.value =
        imageFiles.map((element) => element).toList();

    addController.imageMedia.value =
        imageMedia.map((element) => element).toList();
  }

  Future<void> uploadTempAdImages(List<File> imageFiles, int adId) async {
    final cancelLoading = Toasts.showToastLoading();
    try {
      final formData = dio.FormData();

      for (final imageFile in imageFiles) {
        formData.files.add(MapEntry(
          'images[]',
          await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ));
      }

      final dio.Response response = await _dataLayer.postFormData(
        '/advertisements/$adId/temporary-images', // Correct endpoint
        formData: formData,
      );

      if (response.statusCode == 200 && response.data is List) {
        final urls = (response.data as List)
            .map((item) => ImageMedia.fromJson(item))
            .toList();
        imageMedia.addAll(urls);
        update(['images_preview']);
      } else {
        print('Unexpected response: ${response.data}');
      }
    } catch (e) {
      print('Image upload failed: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء رفع الصور.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      cancelLoading();
    }
  }

  void setAsMainImage(int index) {
    if (useLocalFiles) {
      if (index < 0 || index >= imageFiles.length) return;
      final image = imageFiles.removeAt(index);
      imageFiles.insert(0, image);
    } else {
      if (index < 0 || index >= imageMedia.length) return;
      final image = imageMedia.removeAt(index);
      imageMedia.insert(0, image);
    }
    update(['images_preview']);
  }
}
