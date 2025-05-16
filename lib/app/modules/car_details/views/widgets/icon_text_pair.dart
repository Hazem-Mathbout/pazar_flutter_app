// Custom Widget for Icon + Text Pair
import 'package:flutter/material.dart';

class IconTextPair extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTextPair(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 4, horizontal: 12), // Margins
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x1A000000), // Hex: #0000001A (10% opacity black)
          width: 1, // 1px border width
        ),
        borderRadius: BorderRadius.circular(60), // Rounded corners
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensures the row wraps content
        children: [
          Icon(icon, color: Colors.black, size: 20), // Icon with 20px size
          const SizedBox(width: 6), // Space between icon and text
          Text(
            text,
            style: const TextStyle(
              fontFamily: "Rubik",
              fontWeight: FontWeight.w400, // Matches font-weight: 400
              fontSize: 12, // Matches font-size: 12px
              height: 16 / 12, // Line-height calculation
              letterSpacing: 0, // Explicitly setting to 0
            ),
          ),
        ],
      ),
    );
  }
}
