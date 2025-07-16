import 'dart:io';

import 'package:get/get.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/utilities_models.dart';

class UtilitiesService extends GetxService {
  final DataLayer _dataLayer = Get.put(DataLayer(), permanent: true);

  List<Make> makes = [];
  List<ColorItem> interiorColors = [];
  List<ColorItem> exteriorColors = [];
  List<BodyType> bodyTypes = [];
  List<Province> provinces = [];
  List<RegionalSpecs> regionalSpecs = [];

  List<PageItem> pages = [];

  String? whatsappContactUrl;
  String? latestMobileAppVersion;
  String? lastMandatoryMobileAppVersion;
  String? androidAppUrlUpdate;
  String? iosAppUrlUpdate;

  late SharedPreferences _prefs;

  Future<UtilitiesService> init() async {
    await fetchUtilities();
    await fetchPages();
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Getter for SharedPreferences instance
  SharedPreferences get prefs => _prefs;

  Future<void> fetchUtilities() async {
    try {
      final response = await _dataLayer.get('/utilities');

      if (response.statusCode == 200) {
        final data = response.data;

        makes = List<Make>.from(data['makes'].map((e) => Make.fromJson(e)));
        interiorColors = List<ColorItem>.from(
            data['interior_colors'].map((e) => ColorItem.fromJson(e)));
        exteriorColors = List<ColorItem>.from(
            data['exterior_colors'].map((e) => ColorItem.fromJson(e)));
        bodyTypes = List<BodyType>.from(
            data['body_types'].map((e) => BodyType.fromJson(e)));

        provinces = List<Province>.from(
            data['provinces'].map((e) => Province.fromJson(e)));

        regionalSpecs = List<RegionalSpecs>.from(
            data['regional_specs'].map((e) => RegionalSpecs.fromJson(e)));

        whatsappContactUrl = data['whatsapp_contact_url'];

        // App Info
        latestMobileAppVersion = data['mobile_app']['latest_version'];
        lastMandatoryMobileAppVersion = data['mobile_app']['mandatory_version'];

        androidAppUrlUpdate = data['mobile_app']['android_url'];
        iosAppUrlUpdate = data['mobile_app']['ios_url'];

        print('Utilities loaded in service ✅');
      } else {
        print('Failed to load utilities with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading utilities: $e');
    }
  }

  String? getAppUrlUpdate() {
    if (Platform.isAndroid) return androidAppUrlUpdate;
    if (Platform.isIOS) return iosAppUrlUpdate;
    return null;
  }

  Future<void> fetchPages() async {
    try {
      final response = await _dataLayer.get('/contents');

      if (response.statusCode == 200) {
        final data = response.data;

        pages = List<PageItem>.from(
          data['pages'].map((e) => PageItem.fromJson(e)),
        );

        print('Pages loaded in service ✅');
      } else {
        print('Failed to load pages with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading pages: $e');
    }
  }

  /// Checks if an app update is required
  /// Returns:
  /// - `true` if a forced update is required
  /// - `false` if no update or optional update is available
  // bool checkForAppUpdate(String currentAppVersion) {
  //   if (latestMobileAppVersion == null ||
  //       lastMandatoryMobileAppVersion == null) {
  //     return false;
  //   }

  //   try {
  //     final currentVersion = _parseVersion(currentAppVersion);
  //     final latestVersion = _parseVersion(latestMobileAppVersion!);
  //     final mandatoryVersion = _parseVersion(lastMandatoryMobileAppVersion!);

  //     // If current version is lower than mandatory version, force update
  //     if (_compareVersions(currentVersion, mandatoryVersion) < 0) {
  //       return true;
  //     }

  //     // If current version is lower than latest version (but higher than mandatory), optional update
  //     if (_compareVersions(currentVersion, latestVersion) < 0) {
  //       return false; // Not forced, but update available
  //     }

  //     return false; // No update needed
  //   } catch (e) {
  //     print('Error comparing versions: $e');
  //     return false;
  //   }
  // }

  /// Returns the update type:
  /// - `UpdateType.forced` if mandatory update required
  /// - `UpdateType.optional` if optional update available
  /// - `UpdateType.none` if no update needed
  UpdateType getUpdateType(String currentAppVersion) {
    if (latestMobileAppVersion == null ||
        lastMandatoryMobileAppVersion == null) {
      return UpdateType.none;
    }

    // For Testting
    // latestMobileAppVersion = "1.0.0";
    // lastMandatoryMobileAppVersion = "1.0.0";
    // For Testting

    try {
      final currentVersion = _parseVersion(currentAppVersion);
      final latestVersion = _parseVersion(latestMobileAppVersion!);
      final mandatoryVersion = _parseVersion(lastMandatoryMobileAppVersion!);

      if (_compareVersions(currentVersion, mandatoryVersion) < 0) {
        return UpdateType.forced;
      }

      if (_compareVersions(currentVersion, latestVersion) < 0) {
        return UpdateType.optional;
      }

      return UpdateType.none;
    } catch (e) {
      print('Error comparing versions: $e');
      return UpdateType.none;
    }
  }

  /// Helper function to parse version string into comparable parts
  List<int> _parseVersion(String version) {
    // Remove any build numbers after '+' if present
    final cleanVersion = version.split('+').first;
    return cleanVersion.split('.').map((e) => int.parse(e)).toList();
  }

  /// Helper function to compare two version numbers
  int _compareVersions(List<int> v1, List<int> v2) {
    for (var i = 0; i < v1.length; i++) {
      if (i >= v2.length) return 1; // v1 is longer (newer)
      if (v1[i] > v2[i]) return 1;
      if (v1[i] < v2[i]) return -1;
    }
    if (v2.length > v1.length) return -1; // v2 is longer (newer)
    return 0; // equal
  }
}

enum UpdateType {
  forced,
  optional,
  none,
}
