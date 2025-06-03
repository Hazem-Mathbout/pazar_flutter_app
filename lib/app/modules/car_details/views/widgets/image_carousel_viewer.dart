import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/car_details/views/full_screen_image_slider.dart';

class ImageCarouselViewer extends StatelessWidget {
  final List<ImageMedia> media;
  final Function(int) onIndexChanged;
  final int currentIndex;

  const ImageCarouselViewer({
    super.key,
    required this.media,
    required this.onIndexChanged,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 294,
          child: ClipRRect(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 294,
                viewportFraction: 1,
                onPageChanged: (index, _) => onIndexChanged(index),
              ),
              items: media.map((img) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageSlider(
                          images: media,
                          initialIndex: currentIndex,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(img.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildImageIndicator(media.length, currentIndex),
        ),
        Positioned(
          top: kToolbarHeight,
          right: 16,
          child: _buildBackButton(),
        ),
      ],
    );
  }

  // Widget _buildImageIndicator(int length, int index) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: Colors.black54,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       '${index + 1}/$length',
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //   );
  // }

  // Widget _buildBackButton() {
  //   return const BackButton(color: Colors.white);
  // }

  Widget _buildImageIndicator(int total, int currentIndex) {
    return Container(
      constraints: const BoxConstraints(minWidth: 52), // optional
      height: 28,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0x7A000000),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          "${currentIndex + 1}/$total",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Rubik",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        width: 32,
        height: 32,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Transform.translate(
            offset: const Offset(-3, 0),
            child: const Icon(Icons.arrow_back_ios,
                color: AppColors.foregroundSecondary, size: 20),
          ),
        ),
      ),
    );
  }
}
