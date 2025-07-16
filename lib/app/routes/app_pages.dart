import 'package:get/get.dart';
import 'package:pazar/app/modules/auth/bindings/auth_binding.dart';
// import 'package:pazar/app/modules/auth/middleware/auth_middleware.dart';
import 'package:pazar/app/modules/auth/views/auth_screen.dart';
import 'package:pazar/app/modules/auth/views/otp_verficiation_screen.dart';
// import 'package:pazar/app/modules/home/views/home_screen.dart';
import 'package:pazar/app/modules/my_ads/binding/my_ads_binding.dart';
import 'package:pazar/app/modules/my_ads/views/my_ads_screen.dart';
import 'package:pazar/app/modules/new_ad/middleware/new_ad_middleware.dart';
import 'package:pazar/app/modules/new_ad/views/edit_ad_images_screen.dart';
import '../modules/car_details/bindings/car_details_binding.dart';
import '../modules/car_details/views/car_details_screen.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_screen.dart';
import '../modules/conversation/bindings/conversation_binding.dart';
import '../modules/conversation/views/conversation_screen.dart';
import '../modules/cars/bindings/home_binding.dart';
import '../modules/cars/views/cars_screen.dart';
import '../modules/new_ad/bindings/new_ad_binding.dart';
import '../modules/new_ad/views/new_ad_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CARS;

  static final routes = [
    // GetPage(
    //   name: _Paths.SPLASH_SCREEN,
    //   page: () => const SplashScreen(),
    // ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthScreen(),
      binding: AuthBinding(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.OTPVERFICIATION,
      page: () => OtpVerficiationScreen(),
    ),
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => HomeScreen(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: _Paths.CARS,
      page: () => CarsScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsScreen(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.CONVERSATION,
      page: () => const ConversationScreen(),
      binding: ConversationBinding(),
    ),
    GetPage(
      name: _Paths.CAR_DETAILS,
      page: () => CarDetailsScreen(),
      binding: CarDetailsBinding(),
    ),
    GetPage(
        name: _Paths.NEW_AD,
        page: () => NewAdScreen(isEditMode: false),
        binding: NewAdBinding(),
        middlewares: [NewAdMiddleware()]
        // fullscreenDialog: true,
        ),
    GetPage(
      name: _Paths.EDIT_AD_IMAGES,
      page: () => EditAdImagesScreen(useLocalFiles: true, adID: null),
      // binding: NewAdBinding(),
      // fullscreenDialog: true,
    ),
    GetPage(
      name: _Paths.MY_ADS,
      page: () => MyAdsScreen(),
      binding: MyAdsBinding(),
    ),
  ];
}
