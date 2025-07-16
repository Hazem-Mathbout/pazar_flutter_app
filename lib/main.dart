// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:get/get.dart';
// import 'package:pazar/app/core/values/app_theme.dart';
// import 'package:pazar/splash_screen.dart';
// // import 'package:pazar/splash_screen.dart';
// import 'app/core/utilities_service.dart';
// import 'app/routes/app_pages.dart'; // Import GetX app pages
// import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//   // Inject your services before the app starts
//   // await Get.putAsync(() => UtilitiesService().init());

//   // FlutterNativeSplash.remove();

//   runApp(const PreApp());
// }

// /// This widget handles async init before showing main app
// class PreApp extends StatefulWidget {
//   const PreApp({super.key});

//   @override
//   State<PreApp> createState() => _PreAppState();
// }

// class _PreAppState extends State<PreApp> {
//   late Future<void> _initFuture;

//   @override
//   void initState() {
//     super.initState();
//     _initFuture = initializeApp();
//   }

//   Future<void> initializeApp() async {
//     // Set system UI overlay style to dark color
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         systemNavigationBarColor:
//             Colors.white, // Set to any dark color you prefer
//         systemNavigationBarIconBrightness:
//             Brightness.dark, // Makes icons visible
//       ),
//     );
//     await Get.putAsync(() => UtilitiesService().init());
//     // await Future.delayed(const Duration(minutes: 2));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return const MyApp();
//         } else {
//           return const MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: CustomSplashScreen(),
//           );
//         }
//       },
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Pazar App',
//       debugShowCheckedModeBanner: false, // Remove debug banner
//       theme: AppTheme.lightTheme,
//       // theme: ThemeData(
//       //   primarySwatch: Colors.red, // Use red as a base swatch
//       //   scaffoldBackgroundColor: AppColors.lightGrey, // Set default background
//       //   fontFamily: 'Rubik', // Example font, replace if you have a specific one
//       //   appBarTheme: const AppBarTheme(
//       //     backgroundColor: Colors.white,
//       //     foregroundColor: Colors.black87, // Color for icons and text in AppBar
//       //     elevation: 1.0,
//       //     iconTheme: IconThemeData(color: Colors.black54),
//       //     titleTextStyle: TextStyle(
//       //       color: Colors.black87,
//       //       fontSize: 18,
//       //       fontWeight: FontWeight.w500,
//       //     ),
//       //   ),
//       //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       //     backgroundColor: Colors.white,
//       //     selectedItemColor: AppColors.primaryRed,
//       //     unselectedItemColor: AppColors.darkGrey,
//       //     type: BottomNavigationBarType.fixed,
//       //     showUnselectedLabels: true,
//       //     elevation: 5.0,
//       //   ),
//       // ),
//       defaultTransition: Transition.fade, // Smooth transitions
//       getPages: AppPages.routes, // Use GetX route management
//       initialRoute: AppPages.INITIAL, // Define initial route
//       locale: const Locale('ar', ''), // Set Arabic as the default locale
//       builder: (context, child) {
//         return BotToastInit()(
//             context,
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: child ?? Container(),
//             ));
//       },
//       navigatorObservers: [
//         BotToastNavigatorObserver(),
//       ],
//     );
//   }
// }

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/app_theme.dart';
import 'package:pazar/app/shared/utils/update_app_component.dart';
import 'package:pazar/splash_screen.dart';
import 'app/core/utilities_service.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PreApp());
}

class PreApp extends StatefulWidget {
  const PreApp({super.key});

  @override
  State<PreApp> createState() => _PreAppState();
}

class _PreAppState extends State<PreApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = initializeApp();
  }

  Future<void> initializeApp() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    await Get.putAsync(() => UtilitiesService().init());

    // Wait for app to be fully ready before checking version
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAppVersionAndShowDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CustomSplashScreen(),
          );
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial link if app was launched with a link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Handle link stream while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (err) => debugPrint('Error on link stream: $err'),
    );
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == 'pages') {
      final path = uri.path;
      switch (path) {
        case '/about':
          Get.toNamed(Routes.ABOUT); // Use your GetX route name
          break;
        // Add more cases for other routes
        default:
          debugPrint('Unknown deep link path: $path');
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pazar App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      locale: const Locale('ar', ''),
      builder: (context, child) {
        return BotToastInit()(
          context,
          Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? Container(),
          ),
        );
      },
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}
