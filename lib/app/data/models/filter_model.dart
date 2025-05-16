import 'package:pazar/app/data/models/advertisement_model.dart';

class FilterModel {
  int? minPrice;
  int? maxPrice;
  String? condition;
  String? transmission;
  int? minYear;
  int? maxYear;
  int? minMileage;
  int? maxMileage;

  FilterModel({
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.transmission,
    this.minYear,
    this.maxYear,
    this.minMileage,
    this.maxMileage,
  });

  // Reset all filters
  void reset() {
    minPrice = null;
    maxPrice = null;
    // condition = null; // this will be handled in the home screen Taps.
    transmission = null;
    minYear = null;
    maxYear = null;
    minMileage = null;
    maxMileage = null;
  }

  // Convert to query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (condition != null) params['condition'] = condition!;

    if (transmission != null) {
      // Find the English equivalent of the selected transmission
      final localized = MetaLabelOptions.transmissions.firstWhere(
        (element) => element.ar == transmission,
        orElse: () =>
            LocalizedText(ar: transmission!, en: transmission!), // fallback
      );
      params['transmission'] = localized.en;
    }

    if (minYear != null) params['min_year'] = minYear.toString();
    if (maxYear != null) params['max_year'] = maxYear.toString();
    if (minMileage != null) params['min_mileage'] = minMileage.toString();
    if (maxMileage != null) params['max_mileage'] = maxMileage.toString();

    return params;
  }

  // Clone method (optional)
  FilterModel copyWith({
    int? minPrice,
    int? maxPrice,
    String? condition,
    String? transmission,
    int? minYear,
    int? maxYear,
    int? minMileage,
    int? maxMileage,
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
    );
  }
}
