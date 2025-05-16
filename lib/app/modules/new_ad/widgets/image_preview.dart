import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/new_ad/controllers/edit_ad_images_controller.dart';
import 'package:pazar/app/modules/new_ad/controllers/new_ad_controller.dart';
import 'package:pazar/app/modules/new_ad/views/edit_ad_images_screen.dart';

class ImagePreview extends StatelessWidget {
  final List<File>? imageFiles;
  final List<ImageMedia>? imagePaths; // URLs from API
  final int? adID;

  const ImagePreview({
    super.key,
    this.imageFiles,
    this.imagePaths,
    required this.adID,
  });

  bool get _useLocalFiles => imageFiles != null && imageFiles!.isNotEmpty;
  bool get _useNetworkImages => imagePaths != null && imagePaths!.isNotEmpty;

  int get _totalImages => _useLocalFiles
      ? imageFiles!.length
      : (_useNetworkImages ? imagePaths!.length : 0);

  ImageProvider _getImage(int index) {
    if (_useLocalFiles) {
      return FileImage(imageFiles![index]);
    } else if (_useNetworkImages) {
      return NetworkImage(imagePaths![index].url);
    } else {
      throw Exception('No valid image source');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_useLocalFiles && !_useNetworkImages) {
      return const SizedBox(); // Or show an empty placeholder
    }

    const int maxGridImages = 8;
    final bool hasMoreImages = _totalImages > maxGridImages;
    final int displayedImages =
        hasMoreImages ? maxGridImages - 1 : _totalImages - 1;
    final int remainingCount = _totalImages - maxGridImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Image Box
        Stack(
          children: [
            Container(
              // width: 352,
              height: 200.22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: _getImage(0),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Overlay label
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.image, size: 16, color: Color(0xFF404040)),
                    SizedBox(width: 4),
                    Text(
                      "الصورة الرئيسية",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 16 / 12,
                        color: Color(0xFF404040),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // GridView for remaining images
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 86.5 / 49.2,
          ),
          itemCount: hasMoreImages ? maxGridImages : _totalImages - 1,
          itemBuilder: (context, index) {
            final isLastItem = hasMoreImages && index == maxGridImages - 1;

            return Stack(
              children: [
                Container(
                  width: 86.5,
                  height: 49.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: _getImage(index + 1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isLastItem)
                  Container(
                    width: 86.5,
                    height: 49.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "+$remainingCount",
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundBrand,
            fixedSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          onPressed: () {
            Get.to(() {
              final editController = Get.find<EditAdImagesController>();
              editController.initImages(imageFiles ?? [], imagePaths ?? []);

              return GetBuilder<NewAdController>(
                id: 'images_preview',
                builder: (controller) => EditAdImagesScreen(
                  useLocalFiles: adID == null,
                  // imagePaths: imagePaths,
                  adID: adID,
                ),
              );
            });
            // Get.toNamed(
            //   Routes.EDIT_AD_IMAGES,
            //   // arguments: {'images': imageFiles ?? imagePaths},
            // );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "تعديل",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 20 / 16,
                  letterSpacing: 0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
