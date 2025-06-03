// // Represents the car information displayed in a card within the chat
// class CarInfoModel {
//   final String id; // Unique car ID
//   final String name;
//   final String year;
//   final String specs; // e.g., "اوتوماتيك"
//   final String price; // Formatted price string, e.g., "24,000$"
//   final String mainImage; // Main image (cover image)
//   final List<String> images; // Additional car images

//   CarInfoModel({
//     required this.id,
//     required this.name,
//     required this.year,
//     required this.specs,
//     required this.price,
//     required this.mainImage,
//     required this.images,
//   });

//   // Example factory to create dummy car info based on the image
//   factory CarInfoModel.dummy() {
//     return CarInfoModel(
//       id: 'bmw-a5-2018', // Example ID
//       name: 'سيارة BMW 2018',
//       year: '2018', // Assuming year from name
//       specs: 'اوتوماتيك',
//       price: '24,000\$',
//       mainImage: 'https://picsum.photos/400/300', // Cover image
//       images: [
//         'https://picsum.photos/400/300?random=1',
//         'https://picsum.photos/400/300?random=2',
//         'https://picsum.photos/400/300?random=3',
//       ], // Example images
//     );
//   }

//   // Convert model to a Map for passing via Get.arguments if needed
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'year': year,
//         'specs': specs,
//         'price': price,
//         'mainImage': mainImage,
//         'images': images,
//       };

//   // Create model from a Map (e.g., when receiving from Get.arguments)
//   factory CarInfoModel.fromJson(Map<String, dynamic> json) {
//     return CarInfoModel(
//       id: json['id'] ?? 'unknown-car',
//       name: json['name'] ?? 'Unknown Car',
//       year: json['year'] ?? 'N/A',
//       specs: json['specs'] ?? 'N/A',
//       price: json['price'] ?? 'N/A',
//       mainImage: json['mainImage'] ?? 'https://via.placeholder.com/400x300',
//       images: List<String>.from(json['images'] ?? []), // Ensure it's a list
//     );
//   }
// }

// List<CarInfoModel> dummyCars = [
//   CarInfoModel(
//     id: 'bmw-x5-2020',
//     name: 'BMW X5 2020',
//     year: '2020',
//     specs: 'اوتوماتيك - دفع رباعي',
//     price: '55,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=1',
//     images: [
//       'https://picsum.photos/400/300?random=10',
//       'https://picsum.photos/400/300?random=11',
//       'https://picsum.photos/400/300?random=12',
//     ],
//   ),
//   CarInfoModel(
//     id: 'mercedes-c200-2019',
//     name: 'مرسيدس C200 2019',
//     year: '2019',
//     specs: 'اوتوماتيك - بنزين',
//     price: '47,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=2',
//     images: [
//       'https://picsum.photos/400/300?random=13',
//       'https://picsum.photos/400/300?random=14',
//     ],
//   ),
//   CarInfoModel(
//     id: 'audi-a6-2021',
//     name: 'Audi A6 2021',
//     year: '2021',
//     specs: 'اوتوماتيك - ديزل',
//     price: '60,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=3',
//     images: [
//       'https://picsum.photos/400/300?random=15',
//       'https://picsum.photos/400/300?random=16',
//       'https://picsum.photos/400/300?random=17',
//     ],
//   ),
//   CarInfoModel(
//     id: 'toyota-camry-2018',
//     name: 'تويوتا كامري 2018',
//     year: '2018',
//     specs: 'اوتوماتيك - هايبرد',
//     price: '30,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=4',
//     images: [
//       'https://picsum.photos/400/300?random=18',
//       'https://picsum.photos/400/300?random=19',
//     ],
//   ),
//   CarInfoModel(
//     id: 'ford-mustang-2022',
//     name: 'فورد موستانج 2022',
//     year: '2022',
//     specs: 'اوتوماتيك - رياضي',
//     price: '70,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=5',
//     images: [
//       'https://picsum.photos/400/300?random=20',
//       'https://picsum.photos/400/300?random=21',
//       'https://picsum.photos/400/300?random=22',
//     ],
//   ),
//   CarInfoModel(
//     id: 'honda-civic-2020',
//     name: 'هوندا سيفيك 2020',
//     year: '2020',
//     specs: 'اوتوماتيك - اقتصادي',
//     price: '25,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=6',
//     images: [
//       'https://picsum.photos/400/300?random=23',
//       'https://picsum.photos/400/300?random=24',
//     ],
//   ),
//   CarInfoModel(
//     id: 'nissan-altima-2017',
//     name: 'نيسان التيما 2017',
//     year: '2017',
//     specs: 'اوتوماتيك - اقتصادي',
//     price: '22,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=7',
//     images: [
//       'https://picsum.photos/400/300?random=25',
//       'https://picsum.photos/400/300?random=26',
//     ],
//   ),
//   CarInfoModel(
//     id: 'chevrolet-tahoe-2023',
//     name: 'شيفروليه تاهو 2023',
//     year: '2023',
//     specs: 'اوتوماتيك - SUV',
//     price: '80,000\$',
//     mainImage: 'https://picsum.photos/400/300?random=8',
//     images: [
//       'https://picsum.photos/400/300?random=27',
//       'https://picsum.photos/400/300?random=28',
//     ],
//   ),
// ];

import 'dart:developer';

import 'package:pazar/app/data/models/utilities_models.dart';
import 'package:pazar/app/shared/utils/validate_json_types.dart';

class Advertisement {
  final int id;
  final String reference;
  final String title;
  final String description;
  final String price;
  final int year;
  final String mileage;
  final String condition;
  final String transmission;
  final String fuelType;
  final String? bodyType;
  final String? seats;
  final String doors;
  final String? interiorColor;
  final String? exteriorColor;
  final String address;
  final String? province;
  String status;
  final int viewsCount;
  final Seller seller;
  final Make make;
  final Make model;
  final LocalizedText modelFullName;

  ///the key of the Regional Specs, and then fetch the label from the util.
  final String? regionalSpecs;
  final List<ImageMedia> media;
  final MetaLabels? metaLabels;
  bool favoritedByAuth;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    required this.id,
    required this.reference,
    required this.title,
    required this.description,
    required this.price,
    required this.year,
    required this.mileage,
    required this.condition,
    required this.transmission,
    required this.fuelType,
    this.bodyType,
    this.seats,
    required this.doors,
    this.interiorColor,
    this.exteriorColor,
    required this.address,
    required this.province,
    required this.status,
    required this.viewsCount,
    required this.seller,
    required this.make,
    required this.model,
    required this.modelFullName,
    required this.media,
    required this.favoritedByAuth,
    this.metaLabels,
    this.regionalSpecs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    // factory Advertisement.fromJson(Map<String, dynamic> json) {
    // json.forEach((key, value) {
    //   log("Key: $key, Type: ${value.runtimeType}, Value: $value");
    // });

    // // Define expected types
    // final expectedTypes = {
    //   'id': int,
    //   'reference': String,
    //   'title': String,
    //   'description': String,
    //   'price': String,
    //   'year': int,
    //   'mileage': String,
    //   'condition': String,
    //   'transmission': String,
    //   'fuel_type': String,
    //   'body_type': String,
    //   'seats': String,
    //   'doors': String,
    //   'interior_color': String,
    //   'exterior_color': String,
    //   'address': String,
    //   'province': String,
    //   'status': String,
    //   'views_count': int,
    //   'seller': Map<String, dynamic>,
    //   'make': Map<String, dynamic>,
    //   'model': Map<String, dynamic>,
    //   'images': List,
    //   'meta_labels': Map<String, dynamic>,
    //   'created_at': String,
    //   'updated_at': String,
    // };

    // // Validate JSON types (for debug)
    // validateJsonTypes(expectedTypes, json);

    // Proceed with parsing
    return Advertisement(
      id: json['id'],
      reference: json['reference'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      year: int.tryParse(json['year'].toString()) ?? -1,
      mileage: json['mileage'],
      condition: json['condition'],
      transmission: json['transmission'],
      fuelType: json['fuel_type'],
      bodyType: json['body_type'],
      seats: json['seats'],
      doors: json['doors'],
      interiorColor: json['interior_color'],
      exteriorColor: json['exterior_color'],
      address: json['address'],
      province: json['province'],
      status: json['status'],
      viewsCount: json['views_count'],
      seller: Seller.fromJson(json['seller']),
      make: json['make'] != null ? Make.fromJson(json['make']) : Make.empty(),
      model:
          json['model'] != null ? Make.fromJson(json['model']) : Make.empty(),
      modelFullName: LocalizedText.fromJson(json['model_fullname']),
      media: (json['images'] as List<dynamic>? ?? [])
          .map((img) => ImageMedia.fromJson(img))
          .toList(),
      metaLabels: json['meta_labels'] != null
          ? MetaLabels.fromJson(json['meta_labels'])
          : null,
      regionalSpecs: json['regional_specs'],
      favoritedByAuth: json['favorited_by_auth'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert Advertisement object to JSON (useful for sending requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'title': title,
      'description': description,
      'price': price,
      'year': year,
      'mileage': mileage,
      'condition': condition,
      'transmission': transmission,
      'fuel_type': fuelType,
      'body_type': bodyType,
      'seats': seats,
      'doors': doors,
      'interior_color': interiorColor,
      'exterior_color': exteriorColor,
      'address': address,
      'province': province,
      'status': status,
      'views_count': viewsCount,
      'seller': seller.toJson(),
      'make': make.toJson(),
      'model': model.toJson(),
      'model_fullname': modelFullName.toJson(),
      'images': media.map((m) => m.toJson()).toList(),
      'meta_labels': metaLabels?.toJson(),
      'regional_specs': regionalSpecs,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LocalizedText? getFuelTypeLabel(String fuelType) {
    return MetaLabelOptions.fuelTypes.firstWhere(
      (f) => f.en.toLowerCase() == fuelType.toLowerCase(),
      orElse: () => LocalizedText(ar: fuelType, en: fuelType),
    );
  }

  LocalizedText? getTransmissions(String transmission) {
    return MetaLabelOptions.transmissions.firstWhere(
      (f) => f.en.toLowerCase() == transmission.toLowerCase(),
      orElse: () => LocalizedText(ar: transmission, en: transmission),
    );
  }

  LocalizedText? getConditions(String condition) {
    return MetaLabelOptions.conditions.firstWhere(
      (f) => f.en.toLowerCase() == condition.toLowerCase(),
      orElse: () => LocalizedText(ar: condition, en: condition),
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String whatsappNumber;
  final String? profileImageUrl;
  final bool businessAccount;
  final bool verified;

  Seller({
    required this.id,
    required this.name,
    required this.whatsappNumber,
    this.profileImageUrl,
    required this.businessAccount,
    required this.verified,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'],
      whatsappNumber: json['whatsapp_number'],
      profileImageUrl: json['profile_image_url'],
      businessAccount: json['business_account'] ?? false,
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'whatsapp_number': whatsappNumber,
      'profile_image_url': profileImageUrl,
      'business_account': businessAccount,
      'verified': verified,
    };
  }
}

class ImageMedia {
  final int id;
  final String url;
  final Map<String, String> thumbnailUrl;

  ImageMedia({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  factory ImageMedia.fromJson(Map<String, dynamic> json) {
    return ImageMedia(
      id: json['id'],
      url: json['url'],
      thumbnailUrl: Map<String, String>.from(json['thumbnail_url'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnail_url': thumbnailUrl,
    };
  }
}

class MetaLabels {
  final LocalizedText? location;
  final String? milage;
  final int? year;
  final LocalizedText? condition;
  final LocalizedText? transmission;
  final LocalizedText? fuelType;

  MetaLabels({
    this.location,
    this.milage,
    this.year,
    this.condition,
    this.transmission,
    this.fuelType,
  });

  factory MetaLabels.fromJson(Map<String, dynamic> json) {
    return MetaLabels(
      location: json['location'] != null
          ? LocalizedText.fromJson(json['location'])
          : null,
      milage: json['milage']?.toString(),
      year: int.tryParse(json['year'].toString()) ?? -1,
      condition: json['condition'] != null
          ? LocalizedText.fromJson(json['condition'])
          : null,
      transmission: json['transmission'] != null
          ? LocalizedText.fromJson(json['transmission'])
          : null,
      fuelType: json['fuel_type'] != null
          ? LocalizedText.fromJson(json['fuel_type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'milage': milage,
      'year': year,
      'condition': condition?.toJson(),
      'transmission': transmission?.toJson(),
      'fuel_type': fuelType?.toJson(),
    };
  }
}

class LocalizedText {
  final String ar;
  final String en;

  LocalizedText({required this.ar, required this.en});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      ar: json['ar'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ar': ar,
        'en': en,
      };
}

class MetaLabelOptions {
  static List<LocalizedText> fuelTypes = [
    LocalizedText(ar: 'بنزين', en: 'Petrol'),
    LocalizedText(ar: 'ديزل', en: 'Diesel'),
    LocalizedText(ar: 'كهرباء', en: 'Electric'),
    LocalizedText(ar: 'هايبرد', en: 'Hybrid'),
    LocalizedText(ar: 'غاز', en: 'Gas'),
  ];

  static List<LocalizedText> transmissions = [
    LocalizedText(ar: 'يدوي', en: 'Manual'),
    LocalizedText(ar: 'أوتوماتيكي', en: 'Automatic'),
    LocalizedText(ar: 'شبه أوتوماتيكي', en: 'Semi-Automatic'),
  ];

  static List<LocalizedText> conditions = [
    LocalizedText(ar: 'جديد', en: 'New'),
    LocalizedText(ar: 'مستعمل', en: 'Used'),
  ];
}
