// import 'package:pazar/app/data/models/advertisement_model.dart';

// class FilterModel {
//   int? minPrice;
//   int? maxPrice;
//   String? condition;
//   String? transmission;
//   int? minYear;
//   int? maxYear;
//   int? minMileage;
//   int? maxMileage;

//   FilterModel({
//     this.minPrice,
//     this.maxPrice,
//     this.condition,
//     this.transmission,
//     this.minYear,
//     this.maxYear,
//     this.minMileage,
//     this.maxMileage,
//   });

//   // Reset all filters
//   void reset() {
//     minPrice = null;
//     maxPrice = null;
//     // condition = null; // this will be handled in the home screen Taps.
//     transmission = null;
//     minYear = null;
//     maxYear = null;
//     minMileage = null;
//     maxMileage = null;
//   }

//   // Convert to query params
//   Map<String, String> toQueryParams() {
//     final Map<String, String> params = {};

//     if (minPrice != null) params['min_price'] = minPrice.toString();
//     if (maxPrice != null) params['max_price'] = maxPrice.toString();
//     if (condition != null) params['condition'] = condition!;

//     if (transmission != null) {
//       // Find the English equivalent of the selected transmission
//       final localized = MetaLabelOptions.transmissions.firstWhere(
//         (element) => element.ar == transmission,
//         orElse: () =>
//             LocalizedText(ar: transmission!, en: transmission!), // fallback
//       );
//       params['transmission'] = localized.en;
//     }

//     if (minYear != null) params['min_year'] = minYear.toString();
//     if (maxYear != null) params['max_year'] = maxYear.toString();
//     if (minMileage != null) params['min_mileage'] = minMileage.toString();
//     if (maxMileage != null) params['max_mileage'] = maxMileage.toString();

//     return params;
//   }

//   // Clone method (optional)
//   FilterModel copyWith({
//     int? minPrice,
//     int? maxPrice,
//     String? condition,
//     String? transmission,
//     int? minYear,
//     int? maxYear,
//     int? minMileage,
//     int? maxMileage,
//   }) {
//     return FilterModel(
//       minPrice: minPrice ?? this.minPrice,
//       maxPrice: maxPrice ?? this.maxPrice,
//       condition: condition ?? this.condition,
//       transmission: transmission ?? this.transmission,
//       minYear: minYear ?? this.minYear,
//       maxYear: maxYear ?? this.maxYear,
//       minMileage: minMileage ?? this.minMileage,
//       maxMileage: maxMileage ?? this.maxMileage,
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/utilities_models.dart';

class FilterModel {
  // Existing filters
  int? minPrice;
  int? maxPrice;
  String? condition;
  String? transmission;
  int? minYear;
  int? maxYear;
  int? minMileage;
  int? maxMileage;

  // New filters from API
  String? fuelType;
  String? bodyType;
  int? seats;
  int? doors;
  int? makeId;
  int? modelId;
  String? province;
  List<int>? models; // For multi-selection
  String? make; // For multi-selection

  // New sort option
  String? sortOption; // 'lowest_first', 'priceHighToLow', 'newest', 'oldest'

  FilterModel({
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.transmission,
    this.minYear,
    this.maxYear,
    this.minMileage,
    this.maxMileage,
    this.fuelType,
    this.bodyType,
    this.seats,
    this.doors,
    this.makeId,
    this.modelId,
    this.province,
    this.models,
    this.make,
    this.sortOption = 'lowest_first', // Default value
  });

  // Reset all filters
  void reset() {
    minPrice = null;
    maxPrice = null;
    transmission = null;
    minYear = null;
    maxYear = null;
    minMileage = null;
    maxMileage = null;
    fuelType = null;
    bodyType = null;
    seats = null;
    doors = null;
    makeId = null;
    modelId = null;
    province = null;
    models = null;
    make = null;
    sortOption = 'lowest_first'; // Reset to default
    // condition remains unchanged as per your comment
  }

  // Convert to query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    // Existing params
    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (condition != null) params['condition'] = condition!;

    if (transmission != null) {
      final localized = MetaLabelOptions.transmissions.firstWhere(
        (element) => element.ar == transmission,
        orElse: () => LocalizedText(ar: transmission!, en: transmission!),
      );
      params['transmission'] = localized.en.toLowerCase();
    }

    if (minYear != null) params['min_year'] = minYear.toString();
    if (maxYear != null) params['max_year'] = maxYear.toString();
    if (minMileage != null) params['min_mileage'] = minMileage.toString();
    if (maxMileage != null) params['max_mileage'] = maxMileage.toString();

    // New params
    if (fuelType != null) {
      params['fuel_type'] = _translateToEnglish('fuel_type', fuelType!);
    }
    if (bodyType != null) {
      params['body_type'] = _translateToEnglish('body_type', bodyType!);
    }
    if (province != null) {
      params['province'] = _translateToEnglish('province', province!);
    }
    if (seats != null) params['seats'] = seats.toString();
    if (doors != null) params['doors'] = doors.toString();
    if (makeId != null) params['make_id'] = makeId.toString();
    if (modelId != null) params['model_id'] = modelId.toString();

    // Handle multi-selection
    if (models != null && models!.isNotEmpty) {
      params['model_id'] = models!.join(',');
    }
    if (make != null && make!.isNotEmpty) {
      var makeID = getMakeIdFromArMakeString(make!);
      params['make_id'] = makeID.toString();
    }

    // Add sort parameter
    if (sortOption != null && sortOption != 'lowest_first') {
      params['sortOption'] = sortOption!;
    }

    return params;
  }

  // Helper to translate Arabic selections to English for API
  String _translateToEnglish(String type, String arabicValue) {
    List<LocalizedText> options = [];

    switch (type) {
      case 'fuel_type':
        options = MetaLabelOptions.fuelTypes;
        break;
      case 'body_type':
        options = MetaLabelOptions.bodyTypes;
        break;
      case 'province':
        options = MetaLabelOptions.provinces;
        break;
      default:
        return arabicValue;
    }

    return options
        .firstWhere(
          (element) => element.ar == arabicValue,
          orElse: () => LocalizedText(ar: arabicValue, en: arabicValue),
        )
        .en
        .toLowerCase();
  }

  /// will return the id of the make that corsponding to the arabic make label.
  int getMakeIdFromArMakeString(String arMake) {
    final utilitiesService = Get.find<UtilitiesService>();
    return utilitiesService.makes
        .firstWhere(
          (element) => element.label.ar == make,
          orElse: () => Make.empty(),
        )
        .id;
  }

  // Clone method
  FilterModel copyWith({
    int? minPrice,
    int? maxPrice,
    String? condition,
    String? transmission,
    int? minYear,
    int? maxYear,
    int? minMileage,
    int? maxMileage,
    String? query,
    String? fuelType,
    String? bodyType,
    int? seats,
    int? doors,
    int? makeId,
    int? modelId,
    String? province,
    List<int>? models,
    String? make,
    String? sortOption,
  }) {
    return FilterModel(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      condition: condition ?? this.condition,
      transmission: transmission ?? this.transmission,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      minMileage: minMileage ?? this.minMileage,
      maxMileage: maxMileage ?? this.maxMileage,
      fuelType: fuelType ?? this.fuelType,
      bodyType: bodyType ?? this.bodyType,
      seats: seats ?? this.seats,
      doors: doors ?? this.doors,
      makeId: makeId ?? this.makeId,
      modelId: modelId ?? this.modelId,
      province: province ?? this.province,
      models: models ?? this.models,
      make: make ?? this.make,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
