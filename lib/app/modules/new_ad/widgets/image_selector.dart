import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pazar/app/modules/new_ad/controllers/edit_ad_images_controller.dart';
import 'package:pazar/app/modules/new_ad/controllers/new_ad_controller.dart'; // Add this import

class ImageSelector extends StatelessWidget {
  ImageSelector({
    super.key,
    required this.directUploadAfterSelection,
    required this.adID,
  });

  // Create an instance of ImagePicker
  final ImagePicker _picker = ImagePicker();
  final bool directUploadAfterSelection;
  final int? adID;

  // Access the controller to update the imageFiles list
  final NewAdController controller = Get.find<NewAdController>();
  final editImagesController = Get.find<EditAdImagesController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, //352
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 24, color: Colors.black),
            const SizedBox(height: 16),
            const Text(
              "أضف صورًا إلى إعلانك",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 20 / 14,
                color: Color(0xFF171717),
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 4),
            const Text(
              "قم برفع 5 صور على الأقل",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 16 / 12,
                color: Color(0xFF737373),
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              ),
              onPressed: () async {
                // Pick images using the ImagePicker
                final pickedFiles = await _picker.pickMultiImage();

                if (pickedFiles.isNotEmpty) {
                  // Add the selected images to the controller's imageFiles list
                  if (directUploadAfterSelection) {
                    await editImagesController.uploadTempAdImages(
                      pickedFiles.map((e) => File(e.path)).toList(),
                      adID!,
                    );
                  } else {
                    controller.updateImagesPreview(
                      pickedFiles.map((e) => File(e.path)).toList(),
                    );
                  }
                } else {
                  // Handle the case where no images were picked
                  Get.snackbar(
                    'تحذير',
                    'لم يتم اختيار أي صور',
                    backgroundColor: Colors.yellow,
                    colorText: Colors.black,
                  );
                }
              },
              child: const Text(
                "رفع",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 20 / 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 6;
    const double dashSpace = 4;
    final Paint paint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    // Create dashed effect
    final Path dashedPath = Path();
    for (PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
