import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';

class FullScreenImageSlider extends StatefulWidget {
  final List<ImageMedia> images;
  final int initialIndex;

  const FullScreenImageSlider({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageSlider> createState() => _FullScreenImageSliderState();
}

class _FullScreenImageSliderState extends State<FullScreenImageSlider> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGestureDetectorScope(
            axis: Axis.horizontal, // Prevent swipe conflict with zoom
            child: CarouselSlider.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index, _) {
                return PhotoView(
                  imageProvider: NetworkImage(widget.images[index].url),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 4.0,
                );
              },
              options: CarouselOptions(
                initialPage: _currentIndex,
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) =>
                    setState(() => _currentIndex = index),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
