import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkHandler {
  static late AppLinks _appLinks;
  static StreamSubscription<Uri>? _linkSubscription;

  static Future<void> initDeepLinks(BuildContext context) async {
    _appLinks = AppLinks();

    // Handle initial link if app was launched with a link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri, context);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Handle link stream while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleDeepLink(uri, context),
      onError: (err) => debugPrint('Error on link stream: $err'),
    );
  }

  static void _handleDeepLink(Uri uri, BuildContext context) {
    if (uri.host == 'pages') {
      final path = uri.path;
      switch (path) {
        case '/about':
          Navigator.of(context).pushNamed('/about');
          break;
        // Add more cases for other routes
        default:
          debugPrint('Unknown deep link path: $path');
      }
    }
  }

  static void dispose() {
    _linkSubscription?.cancel();
  }
}
