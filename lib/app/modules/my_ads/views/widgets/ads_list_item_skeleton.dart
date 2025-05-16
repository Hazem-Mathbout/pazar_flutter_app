import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class AdsListItemSkeleton extends StatelessWidget {
  const AdsListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 160,
              height: 130,
              color: Colors.grey[300],
            ),
          ),

          // Content Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + delete icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      skeletonBox(width: 80, height: 20, radius: 50),
                      skeletonBox(width: 30, height: 30),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title placeholder
                  skeletonBox(width: double.infinity, height: 14),
                  const SizedBox(height: 6),

                  // Details row
                  Row(
                    children: [
                      skeletonBox(width: 40, height: 12),
                      const SizedBox(width: 6),
                      skeletonDot(),
                      const SizedBox(width: 6),
                      skeletonBox(width: 40, height: 12),
                      const SizedBox(width: 6),
                      skeletonDot(),
                      const SizedBox(width: 6),
                      skeletonBox(width: 40, height: 12),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price placeholder
                  skeletonBox(width: 60, height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    ).redacted(
      context: context,
      redact: true,
      configuration: RedactedConfiguration(
        animationDuration: const Duration(milliseconds: 800), //default
      ),
    );
  }

  Widget skeletonBox(
      {required double width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget skeletonDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
