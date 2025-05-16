import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart'; // Assuming colors are defined here

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendPressed;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Using SafeArea to avoid keyboard overlap and bottom intrusions
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: const BoxDecoration(
          color: Colors.white, // White background
          border: Border(
            top: BorderSide(
              color: AppColors.borderDefault,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            // Text Input Field
            Expanded(
              child: TextField(
                controller: controller, // Use the passed controller
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...', // Hint text from image
                  hintTextDirection: TextDirection.rtl, // Hint text RTL
                  filled: true,
                  fillColor: Colors.grey[100], // Light grey background
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24.0), // Rounded corners
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                ),
                textDirection: TextDirection.rtl, // Input text RTL
                minLines: 1,
                maxLines: 5, // Allow multiple lines
              ),
            ),
            const SizedBox(width: 12),
            // Send Button
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed, // Red background
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Transform.rotate(
                  // Rotate icon to point up
                  angle: -3.14159 / 2, // -90 degrees in radians
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                ),
                onPressed: onSendPressed, // Use the callback
              ),
            ),
          ],
        ),
      ),
    );
  }
}
