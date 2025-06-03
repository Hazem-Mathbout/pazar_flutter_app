// // Open WhatsApp for help: https://wa.me/message/ZBA4XKHNBA7BH1
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> openWhatsApp() async {
//   try {
//     final Uri whatsappLaunchUri = Uri(
//       scheme: 'https',
//       host: 'wa.me',
//       path: 'message/ZBA4XKHNBA7BH1', // Replace with your WhatsApp number
//     );
//     await launchUrl(whatsappLaunchUri, mode: LaunchMode.externalApplication);
//   } catch (e) {
//     Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة فتح واتساب: $e');
//   }
// }

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openWhatsApp(
    {required String phoneNumber, String? message}) async {
  try {
    final String formattedPhone =
        phoneNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final String encodedMessage = Uri.encodeComponent(message ?? '');
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$formattedPhone${message != null ? '?text=$encodedMessage' : ''}',
    );

    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } catch (e) {
    Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة فتح واتساب: $e');
  }
}
