import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Optional for modern icons
import 'package:pazar/app/routes/app_pages.dart';

class FirstPageErrorIndicator extends StatelessWidget {
  final bool isUnauthorized;
  final String? unauthorizedMessage;
  final String? genericErrorMessage;

  const FirstPageErrorIndicator({
    super.key,
    required this.isUnauthorized,
    this.unauthorizedMessage = "يجب تسجيل الدخول لعرض هذا المحتوى!",
    this.genericErrorMessage = "حصل خطأ ما أثناء تحميل البيانات!",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: isUnauthorized
              ? _buildUnauthorizedContent()
              : _buildGenericErrorContent(),
        ),
      ),
    );
  }

  List<Widget> _buildUnauthorizedContent() {
    return [
      const Icon(
        LucideIcons.lock,
        size: 48,
        color: Colors.orange,
      ),
      const SizedBox(height: 16),
      Text(
        unauthorizedMessage!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: () => Get.toNamed(Routes.AUTH),
        icon: const Icon(Icons.login),
        label: const Text("تسجيل الدخول"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ];
  }

  List<Widget> _buildGenericErrorContent() {
    return [
      const Icon(
        LucideIcons.alertTriangle,
        size: 48,
        color: Colors.redAccent,
      ),
      const SizedBox(height: 16),
      Text(
        genericErrorMessage!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }
}
