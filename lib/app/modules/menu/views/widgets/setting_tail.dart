import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String? iconImage;
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    this.icon,
    this.iconImage,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 24,
                color: AppColors.foregroundSecondary,
              )
            else if (iconImage != null)
              Image.asset(
                iconImage!,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: AppColors.foregroundSecondary,
              ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 20 / 15,
                letterSpacing: -0.5,
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
