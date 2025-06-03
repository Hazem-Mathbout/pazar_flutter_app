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

        print('Utilities loaded in service ✅');
      } else {
        print('Failed to load utilities with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading utilities: $e');
    }
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
}
