import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/routes/app_pages.dart';

class NewAdMiddleware extends GetMiddleware {
  final DataLayer _dataLayer = Get.find<DataLayer>();

  @override
  int get priority => 0; // Optional, define the priority if needed

  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is logged in, for example, by checking the token or session
    bool isLoggedIn = _dataLayer.isLoggedIn();

    // If logged in, navigate to the new ad screen; otherwise, stay on the auth screen
    if (isLoggedIn) {
      return null; // allow access.
    }

    // If not logged in, redirect to the auth screen
    return const RouteSettings(name: Routes.AUTH);
  }
}
