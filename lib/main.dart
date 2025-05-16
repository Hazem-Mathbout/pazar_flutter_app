import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/app_theme.dart';
import 'package:pazar/splash_screen.dart';
// import 'package:pazar/splash_screen.dart';
import 'app/core/utilities_service.dart';
import 'app/routes/app_pages.dart'; // Import GetX app pages

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inject your services before the app starts
  // await Get.putAsync(() => UtilitiesService().init());

  // FlutterNativeSplash.remove();

  runApp(const PreApp());
}

/// This widget handles async init before showing main app
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
    await Get.putAsync(() => UtilitiesService().init());
    // await Future.delayed(const Duration(minutes: 2));
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pazar App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: AppTheme.lightTheme,
      // theme: ThemeData(
      //   primarySwatch: Colors.red, // Use red as a base swatch
      //   scaffoldBackgroundColor: AppColors.lightGrey, // Set default background
      //   fontFamily: 'Rubik', // Example font, replace if you have a specific one
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.white,
      //     foregroundColor: Colors.black87, // Color for icons and text in AppBar
      //     elevation: 1.0,
      //     iconTheme: IconThemeData(color: Colors.black54),
      //     titleTextStyle: TextStyle(
      //       color: Colors.black87,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //     backgroundColor: Colors.white,
      //     selectedItemColor: AppColors.primaryRed,
      //     unselectedItemColor: AppColors.darkGrey,
      //     type: BottomNavigationBarType.fixed,
      //     showUnselectedLabels: true,
      //     elevation: 5.0,
      //   ),
      // ),
      defaultTransition: Transition.fade, // Smooth transitions
      getPages: AppPages.routes, // Use GetX route management
      initialRoute: AppPages.INITIAL, // Define initial route
      locale: const Locale('ar', ''), // Set Arabic as the default locale
      builder: (context, child) {
        return BotToastInit()(
            context,
            Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? Container(),
            ));
      },
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}
