import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/data_layer.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/utilities_models.dart';
import 'package:pazar/app/modules/car_details/controllers/car_details_controller.dart';
import 'package:pazar/app/modules/my_ads/controllers/my_ads_controller.dart';
import 'package:pazar/app/modules/new_ad/controllers/edit_ad_images_controller.dart';
import 'package:pazar/app/shared/utils/error_handler.dart';
import 'package:pazar/app/shared/utils/toast_loading.dart';

class NewAdController extends GetxController {
  // Dropdown selections
  String? selectedYear;
  String? selectedModel;
  String? selectedModelID;
  String? selectedMake;
  String? selectedMakeID;
  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedBodyType;
  String? selectedInteriorColor;
  String? selectedExteriorColor;
  String? selectedRegionalSpecs;
  String? selectedCarStatus;
  String? selectedProvinc;

  // Images (this should be populated with image file paths)
  var imageFiles = <File>[].obs; // coming from local files.
  var imageMedia = <ImageMedia>[].obs; // coming from api

  // Text fields
  final adNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final mileageController = TextEditingController();
  final addressController = TextEditingController();
  final seatsController = TextEditingController();
  final doorsController = TextEditingController();

  // DataLayer instance to handle requests
  final DataLayer _dataLayer = Get.find<DataLayer>();

  final utilitiesService = Get.find<UtilitiesService>();

  List<String> get yearDropdownItems {
    int currentYear = DateTime.now().year;
    return [
      for (int year = 1990; year <= currentYear; year++) year.toString(),
    ];
  }

  /// For Image Selector [either in add ad screen or edit images screen]
  void updateImagesPreview(List<File> images) {
    print("Get.previousRoute: ${Get.previousRoute}");
    print("Current Route: ${Get.currentRoute}");
    if (Get.currentRoute == '/GetBuilder%3CNewAdController%3E') {
      final editAdImagesController = Get.find<EditAdImagesController>();
      editAdImagesController.imageFiles.addAll(
        images.map((e) => File(e.path)).toList(),
      );
      update(['images_preview']);
    } else {
      imageFiles.addAll(
        images.map((e) => File(e.path)).toList(),
      );
      update(['images_preview']);
    }
  }

  void clearModelFiled() {
    selectedModel = null;
    selectedModelID = null;
    update(['model']);
  }

  void initFileds(Advertisement ad) {
    // Dropdown selections
    selectedYear = ad.year.toString();
    selectedModel = null; // ad.model.name;
    selectedMake = ad.make.name;
    // selectedMake = utilitiesService.makes
    //     .firstWhere(
    //       (element) => element.name == ad.make.name,
    //       orElse: () => Make.empty(),
    //     )
    //     .label['ar'];
    selectedFuelType = ad.getFuelTypeLabel(ad.fuelType)?.ar;
    selectedTransmission = ad.getTransmissions(ad.transmission)?.ar;
    selectedBodyType = utilitiesService.bodyTypes
        .firstWhere(
          (element) => element.key == ad.bodyType,
          // orElse: () => ,
        )
        .name['ar'];
    selectedInteriorColor = utilitiesService.interiorColors
        .firstWhere(
          (element) => element.key == ad.interiorColor,
          // orElse: () => ,
        )
        .name['ar'];
    selectedExteriorColor = utilitiesService.exteriorColors
        .firstWhere(
          (element) => element.key == ad.exteriorColor,
          // orElse: () => ,
        )
        .name['ar'];
    selectedRegionalSpecs = utilitiesService.regionalSpecs
        .firstWhere(
          (element) => element.key == ad.regionalSpecs,
          // orElse: () => ,
        )
        .label['ar'];
    selectedCarStatus = ad.getConditions(ad.condition)?.ar;
    selectedProvinc = utilitiesService.provinces
        .firstWhere(
          (element) => element.key == ad.province,
          // orElse: () => ,
        )
        .name['ar'];

    // May be used to fetch models based on selected make
    selectedMakeID = ad.make.id.toString();

    // Text fields
    adNameController.text = ad.title;
    descriptionController.text = ad.description;
    priceController.text = ad.price;
    mileageController.text = ad.mileage;
    addressController.text = ad.address;
    seatsController.text = ad.seats ?? '';
    doorsController.text = ad.doors;

    update();
  }

  Future<List<Make>> fetchModels(String make) async {
    print("make model is: $make/models");
    if (make.isEmpty) {
      return [];
    }
    try {
      final response = await _dataLayer.get('/makes/$make/models');
      if (response.statusCode == 200) {
        var makeModels =
            List<Make>.from(response.data.map((e) => Make.fromJson(e)));
        return makeModels;
      }
      return [];
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  // Submitting the ad
  Future<void> submitAd() async {
    // Validate the Fields values.
    final result = await validateCarForm(
      selectedYear: selectedYear,
      selectedModel: selectedModel,
      selectedModelID: selectedModelID,
      selectedMake: selectedMake,
      selectedMakeID: selectedMakeID,
      selectedFuelType: selectedFuelType,
      selectedTransmission: selectedTransmission,
      selectedBodyType: selectedBodyType,
      selectedInteriorColor: selectedInteriorColor,
      selectedExteriorColor: selectedExteriorColor,
      selectedRegionalSpecs: selectedRegionalSpecs,
      selectedCarStatus: selectedCarStatus,
      selectedProvinc: selectedProvinc,
      numberOfSelectedImages: imageFiles.length,
    );

    if (result != null) {
      Get.snackbar(
        'تنبيه', // Title of the snackbar
        result, // Message from the validation
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      return;
    }

    // Prepare the form data using Dio's FormData
    var data = {
      'title': adNameController.text,
      'description': descriptionController.text,
      'price': priceController.text,
      'year': selectedYear ?? '',
      'mileage': mileageController.text,
      'address': addressController.text,
      'make_id': selectedMakeID ?? '',
      'model_id': selectedModelID ?? '',
      'seats': seatsController.text,
      'doors': doorsController.text,
      'condition': MetaLabelOptions.conditions
          .firstWhere((e) => e.ar == selectedCarStatus)
          .en
          .toLowerCase(), // selectedCarStatus ?? '',
      'transmission': MetaLabelOptions.transmissions
          .firstWhere((element) => element.ar == selectedTransmission)
          .en
          .toLowerCase(), // selectedTransmission ?? '',
      'fuel_type': MetaLabelOptions.fuelTypes
          .firstWhere((element) => element.ar == selectedFuelType)
          .en
          .toLowerCase(), // selectedFuelType ?? '',
      'body_type': utilitiesService.bodyTypes
          .firstWhere((e) => e.name['ar'] == selectedBodyType)
          .key, // selectedBodyType ?? '',

      'interior_color': utilitiesService.interiorColors
          .firstWhere((e) => e.name['ar'] == selectedInteriorColor)
          .key, // selectedInteriorColor ?? '',
      'exterior_color': utilitiesService.exteriorColors
          .firstWhere((e) => e.name['ar'] == selectedExteriorColor)
          .key, // selectedExteriorColor ?? '',

      'regional_specs': utilitiesService.regionalSpecs
          .firstWhere((e) => e.label['ar'] == selectedRegionalSpecs)
          .key, // selectedRegionalSpecs ?? '',

      'province': utilitiesService.provinces
          .firstWhere((e) => e.name['ar'] == selectedProvinc)
          .key, // selectedProvinc ?? '',
    };
    // Remove model_id if it's empty or null
    if (selectedModelID == null) {
      data.remove('model_id');
    }
    print("car data:\n$data");

    dio.FormData formData = dio.FormData.fromMap(data);

    // If there are no images, add an empty list for the 'images[]' key
    if (imageFiles.isEmpty) {
      formData.files.add(MapEntry('images[]', dio.MultipartFile.fromBytes([])));
    } else {
      // Adding image files to the formData
      for (var imageFile in imageFiles) {
        formData.files.add(
          MapEntry(
            'images[]', // The API expects 'images[]'
            await dio.MultipartFile.fromFile(imageFile.path),
          ),
        );
      }
    }

    final cancelLoading = Toasts.showToastLoading();
    try {
      print(formData.fields);
      print("files uploaded length: ${imageFiles.length}");

      // Sending the form data using DataLayer's postFormData method
      dio.Response response = await _dataLayer.postFormData(
        '/advertisements', // API endpoint
        formData: formData,
      );

      // Handling the response
      if (response.statusCode == 200) {
        print(await response.data);
        Get.back();
        Get.snackbar(
          'تم النشر',
          'تم نشر الإعلان بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('Error: ${response.statusCode}');
        print('Error: ${response.data}');

        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء نشر الإعلان.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء نشر الإعلان.');
      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      cancelLoading();
    }
  }

  // Submitting Edit ad
  Future<void> editAd(int adID) async {
    // Validate the Fields values.
    final result = await validateCarForm(
      selectedYear: selectedYear,
      selectedModel: selectedModel,
      selectedModelID: selectedModelID,
      selectedMake: selectedMake,
      selectedMakeID: selectedMakeID,
      selectedFuelType: selectedFuelType,
      selectedTransmission: selectedTransmission,
      selectedBodyType: selectedBodyType,
      selectedInteriorColor: selectedInteriorColor,
      selectedExteriorColor: selectedExteriorColor,
      selectedRegionalSpecs: selectedRegionalSpecs,
      selectedCarStatus: selectedCarStatus,
      selectedProvinc: selectedProvinc,
      numberOfSelectedImages: imageMedia.length,
    );

    if (result != null) {
      Get.snackbar(
        'تنبيه', // Title of the snackbar
        result, // Message from the validation
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      return;
    }
    // Step 1: Prepare the raw form data (without images_ids)
    final rawFormData = {
      'title': adNameController.text,
      'description': descriptionController.text,
      'price': priceController.text.replaceAll(',', ''),
      'year': selectedYear ?? '',
      'mileage': int.tryParse(mileageController.text.replaceAll(',', '')),
      'condition': MetaLabelOptions.conditions
          .firstWhere((e) => e.ar == selectedCarStatus)
          .en
          .toLowerCase(), // selectedCarStatus ?? '',
      'transmission': MetaLabelOptions.transmissions
          .firstWhere((element) => element.ar == selectedTransmission)
          .en
          .toLowerCase(), // selectedTransmission ?? '',
      'fuel_type': MetaLabelOptions.fuelTypes
          .firstWhere((element) => element.ar == selectedFuelType)
          .en
          .toLowerCase(), // selectedFuelType ?? '',
      'body_type': selectedBodyType ?? '',
      'seats': seatsController.text,
      'doors': doorsController.text,
      'interior_color': selectedInteriorColor ?? '',
      'exterior_color': selectedExteriorColor ?? '',
      'regional_specs': selectedRegionalSpecs ?? '',
      'address': addressController.text,
      'make_id': selectedMakeID,
      'model_id': selectedModelID,
      'province': selectedProvinc,
    };

    // Remove model_id if it's empty or null
    if (selectedModelID == null) {
      rawFormData.remove('model_id');
    }

    // Step 2: Process the raw form data (mapping IDs, names, correcting fields)
    final formDataMap = prepareFormDataWithKeys(
      rawData: rawFormData,
      provinces: utilitiesService.provinces,
      colors: utilitiesService.exteriorColors + utilitiesService.interiorColors,
      bodyTypes: utilitiesService.bodyTypes,
      makes: utilitiesService.makes,
    );

    final cancelLoading = Toasts.showToastLoading();
    try {
      // Step 3: Create FormData manually
      final formData = dio.FormData();

      // Step 4: Add processed fields
      formDataMap.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Step 5: Add images_ids[]
      for (var img in imageMedia) {
        formData.fields.add(MapEntry('images_ids[]', img.id.toString()));
      }

      print(formData.fields);
      print("files uploaded length: ${imageMedia.length}");

      // Step 6: Send request
      dio.Response response = await _dataLayer.postFormData(
        '/advertisements/$adID',
        formData: formData,
      );

      print("Request Status Code is: ${response.statusCode}");
      if (response.statusCode == 200) {
        cancelLoading();
        // response.data.forEach((key, value) {
        //   print('Key: $key, Value Type: ${value.runtimeType}, Value: $value');
        // });
        final carDetailsController = Get.find<CarDetailsController>();
        var newAd = Advertisement.fromJson(response.data);
        carDetailsController.updateCarInfo(newAd);
        final myAdController = Get.find<MyAdsController>();
        myAdController.refreshData();

        Get.back(); // Go back and return the edited ad
        Get.snackbar(
          'تم التعديل',
          'تم تعديل الإعلان بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        cancelLoading();

        print('Error: ${response.statusCode}');
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تعديل الإعلان.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      cancelLoading();
      print(e);
      final errorMessage =
          extractErrorMessage(e, fallback: 'حدث خطأ أثناء تعديل الإعلان.');
      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Map<String, dynamic> prepareFormDataWithKeys({
    required Map<String, dynamic> rawData,
    required List<Province> provinces,
    required List<Make> makes,
    required List<ColorItem> colors,
    required List<BodyType> bodyTypes,
  }) {
    String? resolveProvince(String? name) {
      final province = provinces.firstWhere(
        (p) => p.name.containsValue(name),
        orElse: () => Province(key: '', name: {}),
      );
      return province.key.isNotEmpty ? province.key : name;
    }

    String? resolveMakes(String? name) {
      final make = makes.firstWhere(
        (p) => p.label.containsValue(name),
        orElse: () => Make(id: 0, name: '', label: {}),
      );
      return make.name.isNotEmpty ? make.name : name;
    }

    String? resolveColor(String? name) {
      final color = colors.firstWhere(
        (c) => c.name.containsValue(name),
        orElse: () => ColorItem(key: '', name: {}, hex: ''),
      );
      return color.key.isNotEmpty ? color.key : name;
    }

    String? resolveBodyType(String? name) {
      final body = bodyTypes.firstWhere(
        (b) => b.name.containsValue(name),
        orElse: () => BodyType(key: '', name: {}),
      );
      return body.key.isNotEmpty ? body.key : name;
    }

    return {
      ...rawData,
      'province': resolveProvince(rawData['province']),
      'interior_color': resolveColor(rawData['interior_color']),
      'exterior_color': resolveColor(rawData['exterior_color']),
      'body_type': resolveBodyType(rawData['body_type']),
      'make_id': resolveMakes(rawData['make_id']),
    };
  }

  void firstTimePopulateAdImages(Advertisement ad) {
    if (imageMedia.isEmpty) {
      imageMedia.addAll(ad.media);
    }
  }

  @override
  void onClose() {
    adNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    mileageController.dispose();
    addressController.dispose();
    seatsController.dispose();
    doorsController.dispose();
    super.onClose();
  }

  /// Returns null if all required fields are valid.
  /// If `selectedModelID` is empty, it returns a warning message.
  /// If any required field is missing, it returns a custom error message.
  Future<String?> validateCarForm({
    required String? selectedYear,
    required String? selectedModel,
    required String? selectedModelID,
    required String? selectedMake,
    required String? selectedMakeID,
    required String? selectedFuelType,
    required String? selectedTransmission,
    required String? selectedBodyType,
    required String? selectedInteriorColor,
    required String? selectedExteriorColor,
    required String? selectedRegionalSpecs,
    required String? selectedCarStatus,
    required String? selectedProvinc,
    required int? numberOfSelectedImages,
  }) async {
    final Map<String, String?> requiredFields = {
      'سنة الصنع': selectedYear,
      'الموديل': selectedModel,
      'الشركة المصنعة': selectedMake,
      'رمز الشركة': selectedMakeID,
      'نوع الوقود': selectedFuelType,
      'ناقل الحركة': selectedTransmission,
      'نوع الهيكل': selectedBodyType,
      'اللون الداخلي': selectedInteriorColor,
      'اللون الخارجي': selectedExteriorColor,
      'المواصفات الإقليمية': selectedRegionalSpecs,
      'حالة السيارة': selectedCarStatus,
      'المحافظة': selectedProvinc,
    };

    for (final entry in requiredFields.entries) {
      if (entry.value == null || entry.value!.trim().isEmpty) {
        if (entry.key == 'الموديل') {
          continue;
        }
        return 'الرجاء تحديد ${entry.key}';
      }
    }

    if (numberOfSelectedImages == null || numberOfSelectedImages < 5) {
      return 'الرجاء رفع 5 صور على الأقل.';
    }

    // Special case for model ID
    if (selectedModelID == null || selectedModelID.trim().isEmpty) {
      bool continueSubmission = await showDialog<bool>(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: const Text('⚠️ تنبيه'),
              content: const Text(
                  'المودل للإعلان فارغ، هل تريد المتابعة بنشر الإعلان؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('متابعة'),
                ),
              ],
            ),
          ) ??
          false;

      if (!continueSubmission) return 'يرجى تحديد المودل قبل المتابعة.';
    }

    return null; // All validations passed
  }
}
