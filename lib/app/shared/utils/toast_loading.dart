import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class Toasts {
  static void showToastText(String text, {Color? contentColor}) {
    BotToast.showText(
      text: text,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      duration: const Duration(seconds: 5),
      contentColor:
          contentColor ?? Colors.grey.shade900, // Default value provided here
    );
  }

  /// To hide the Loading just call the Function
  /// returend from this method like this:
  ///
  /// cancel()
  ///
  /// Be Aware when calling this function the loading will shown
  /// to max duration to 1 (minute), and you should to hide it when
  /// you finish from your async method.
  ///
  /// and if your async method not finished in one minute, the loading will
  /// hide automaticlly.
  static void Function() showToastLoading() {
    var cancel = BotToast.showCustomLoading(
      toastBuilder: (_) => Center(
        child: Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white), // Spinner color
          ),
        ),
      ),
      allowClick: false,
      duration: const Duration(minutes: 3),
    );
    return cancel;
  }

  // static void Function() showToastNotification(
  //   String webSiteName,
  //   String urlImg,
  //   String title,
  //   String subtitle,
  //   void Function() onTap,
  // ) {
  //   var cancel = BotToast.showNotification(
  //     leading: (cancelFunc) => CircleAvatarNotifications(
  //       webSiteName: webSiteName,
  //       urlImg: urlImg,
  //     ),
  //     title: (cancelFunc) => Text(title),
  //     subtitle: (cancelFunc) => Text(subtitle),
  //     enableSlideOff: true,
  //     // backgroundColor: Colors.white,
  //     contentPadding: const EdgeInsets.all(8),
  //     duration: const Duration(seconds: 5),
  //     onTap: onTap,
  //   );
  //   return cancel;
  // }

  // static Future<void> showUpdateDialog({
  //   required bool mandatory,
  //   required String appStoreUrl,
  // }) async {
  //   await showDialog(
  //     context: Get.context!,
  //     barrierDismissible:
  //         !mandatory, // Prevent dismissing dialog if update is mandatory,
  //     useSafeArea: true,
  //     builder: (BuildContext context) {
  //       return PopScope(
  //         canPop: !mandatory,
  //         onPopInvoked: (didPop) async =>
  //             mandatory ? await FlutterExitApp.exitApp() : null,
  //         child: Directionality(
  //           textDirection: TextDirection.ltr,
  //           child: AlertDialog(
  //             title: const Text(
  //               'تحديث متاح', // Arabic for 'Update Available'
  //               textDirection:
  //                   TextDirection.rtl, // Right-to-left text direction
  //               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //             ),
  //             content: Text(
  //               mandatory
  //                   ? 'يتوفر تحديث إلزامي. يجب عليك تحديث التطبيق للمتابعة.' // Arabic for 'A mandatory update is available. You must update the app to continue.'
  //                   : 'يتوفر إصدار جديد. هل ترغب في التحديث الآن؟', // Arabic for 'A new version is available. Would you like to update now?'
  //               textDirection:
  //                   TextDirection.rtl, // Right-to-left text direction
  //               style:
  //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             actions: [
  //               if (!mandatory)
  //                 TextButton(
  //                   child: const Text(
  //                     'تخطي', // Arabic for 'Skip'
  //                     textDirection: TextDirection.rtl,
  //                     style:
  //                         TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               TextButton(
  //                 child: const Text(
  //                   'تحديث', // Arabic for 'Update'
  //                   textDirection: TextDirection.rtl,
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                 ),
  //                 onPressed: () {
  //                   // Navigator.of(context).pop();
  //                   _openAppStore(appStoreUrl);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // static Future<void> _openAppStore(String appStoreUrl) async {
  //   final Uri url = Uri.parse(appStoreUrl);

  //   // const String appStoreUrl =
  //   //     'https://apkpure.com/your-app-package-id'; // Replace with your actual app store URL

  //   bool res = await _launchUrl(url);
  //   if (!res) {
  //     // Handle the error if the URL cannot be launched
  //     Get.snackbar(
  //       'Error',
  //       'Could not open the app store. Please try again later.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: const Duration(seconds: 3),
  //       margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  //     );
  //   }
  // }

  // static Future<bool> _launchUrl(Uri url) async {
  //   return await launchUrl(url);
  // }
}
