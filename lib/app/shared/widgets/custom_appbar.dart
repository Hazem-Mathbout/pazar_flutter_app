import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final VoidCallback? onClose;
  final Color backgroundColor;
  final bool showLeading;
  final bool forceLTR;
  final double elevation;
  final TextStyle? titleTextStyle;

  const CustomAppBar({
    super.key,
    this.title,
    this.onClose,
    this.backgroundColor = Colors.transparent,
    this.centerTitle = true,
    this.showLeading = true,
    this.forceLTR = true,
    this.elevation = 0.0,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final closeAction = onClose ?? () => Get.back();

    return Directionality(
      textDirection: forceLTR ? TextDirection.ltr : Directionality.of(context),
      child: AppBar(
        title: title != null ? Text(title!, style: titleTextStyle) : null,
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          color: AppColors.foregroundPrimary,
        ),
        centerTitle: centerTitle,
        elevation: elevation,
        backgroundColor: backgroundColor,
        leading: showLeading
            ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'إغلاق',
                onPressed: closeAction,
                color: AppColors.foregroundSecondary,
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
