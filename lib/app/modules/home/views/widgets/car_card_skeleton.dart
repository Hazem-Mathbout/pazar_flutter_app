import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class CarCardSkeleton extends StatelessWidget {
  const CarCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: Colors.grey[300]),
                      const SizedBox(width: 4),
                      Container(width: 40, height: 10, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(height: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 60, height: 14, color: Colors.grey[300]),
                  ],
                ),
                const SizedBox(height: 8),

                // Make & Model
                Row(
                  children: [
                    Icon(Icons.directions_car,
                        size: 16, color: Colors.grey[300]),
                    const SizedBox(width: 4),
                    Container(width: 100, height: 12, color: Colors.grey[300]),
                  ],
                ),
                const SizedBox(height: 8),

                // Secondary info (4 placeholders in wrap)
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(4, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 16, color: Colors.grey[300]),
                        const SizedBox(width: 4),
                        Container(
                            width: 50, height: 12, color: Colors.grey[300]),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).redacted(
        context: context,
        redact: true,
        configuration: RedactedConfiguration(
          animationDuration: const Duration(milliseconds: 800),
        ),
      ),
    );
  }
}
