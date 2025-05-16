import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomContainer({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(maxWidth: 800),
      margin: const EdgeInsets.only(
        top: 8.0,
        bottom: 0.0,
        right: 8.0,
        left: 8.0,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000), // #0000001F
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.5, // Line height 24px (16 * 1.5)
              letterSpacing: 0.0,
              textBaseline: TextBaseline.alphabetic,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }
}
