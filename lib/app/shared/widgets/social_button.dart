import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          side: const BorderSide(
            color: AppColors.borderDefault, // Border-default
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 23,
              height: 23,
            ),
            const SizedBox(width: 8), // gap between icon and text
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.foregroundSecondary,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
