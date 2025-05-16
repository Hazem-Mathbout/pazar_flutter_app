import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  // Constructor accepts the function as a parameter
  const CustomBottomNavigationBar({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE5E5E5), // Border color (light gray)
                width: 1.0, // Border width
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: onPressed, // Execute the passed function on press
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundBrand, // Background color
                minimumSize:
                    const Size(double.infinity, 48), // Button width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Border radius
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8, // Padding top and bottom
                  horizontal: 16, // Padding left and right
                ),
              ),
              child: Text(
                title, // Text in the button
                style: const TextStyle(
                  fontFamily: 'Rubik', // Font family
                  fontWeight: FontWeight.w500, // Font weight
                  fontSize: 16, // Font size
                  height: 20 /
                      16, // Line height, calculated as line-height / font-size
                  letterSpacing: 0.0, // No letter-spacing
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
