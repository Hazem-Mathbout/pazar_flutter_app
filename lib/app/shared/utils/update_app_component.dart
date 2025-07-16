import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> checkAppVersionAndShowDialog() async {
  try {
    final utilitiesService = Get.find<UtilitiesService>();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final updateType = utilitiesService.getUpdateType(currentVersion);
    log('Update check result: $updateType');

    final platformUrl = utilitiesService.getAppUrlUpdate() ??
        (Platform.isAndroid
            ? 'https://play.google.com/store'
            : 'https://apps.apple.com');

    if (updateType == UpdateType.forced) {
      // Show non-dismissible forced update dialog
      Get.dialog(
        ForceUpdateDialog(updateUrl: platformUrl),
        barrierDismissible: false,
      );
    } else if (updateType == UpdateType.optional) {
      // Check if we've already shown this for current version
      final prefs = utilitiesService.prefs;
      final lastPromptVersion = prefs.getString('lastUpdatePrompt');

      if (lastPromptVersion != currentVersion) {
        Get.dialog(
          OptionalUpdateDialog(updateUrl: platformUrl),
        );
        await prefs.setString('lastUpdatePrompt', currentVersion);
      }
    }
  } catch (e) {
    log('Error in version check: $e');
  }
}

class ForceUpdateDialog extends StatelessWidget {
  final String updateUrl;

  const ForceUpdateDialog({super.key, required this.updateUrl});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('تحديث مطلوب', textAlign: TextAlign.right),
        content: const Text(
          'يجب تحديث التطبيق إلى الإصدار الأحدث للمتابعة. لا يمكنك استخدام التطبيق بدون التحديث.',
          textAlign: TextAlign.right,
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          TextButton(
            onPressed: () {
              // Open app store
              launchUrl(Uri.parse(updateUrl));
            },
            child: const Text('حدث الآن'),
          ),
        ],
      ),
    );
  }
}

class OptionalUpdateDialog extends StatelessWidget {
  final String updateUrl;

  const OptionalUpdateDialog({super.key, required this.updateUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تحديث متاح', textAlign: TextAlign.right),
      content: const Text(
        'يتوفر إصدار أحدث من التطبيق. ننصح بالتحديث للحصول على أفضل تجربة وأحدث الميزات.',
        textAlign: TextAlign.right,
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('لاحقاً'),
        ),
        TextButton(
          onPressed: () {
            // Open app store
            launchUrl(Uri.parse(updateUrl));
            Get.back();
          },
          child: const Text('حدث الآن'),
        ),
      ],
    );
  }
}
