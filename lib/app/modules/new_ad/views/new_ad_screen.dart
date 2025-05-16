import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/utilities_service.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/data/models/utilities_models.dart';
import 'package:pazar/app/modules/new_ad/controllers/edit_ad_images_controller.dart';
import 'package:pazar/app/modules/new_ad/controllers/new_ad_controller.dart';
import 'package:pazar/app/modules/new_ad/widgets/custom_bottom_navigation_bar.dart';
import 'package:pazar/app/modules/new_ad/widgets/custom_container.dart';
import 'package:pazar/app/shared/widgets/custom_appbar.dart';
import 'package:pazar/app/shared/widgets/custom_input_filed.dart';
import 'package:pazar/app/modules/new_ad/widgets/image_preview.dart';
import 'package:pazar/app/modules/new_ad/widgets/image_selector.dart';
import 'package:pazar/app/shared/widgets/custom_searchable_dropdown.dart';

class NewAdScreen extends StatelessWidget {
  NewAdScreen({
    super.key,
    this.advertisement,
    required this.isEditMode,
  });
  final controller = Get.put(NewAdController());
  final editController = Get.put(EditAdImagesController());
  final utilitiesService = Get.find<UtilitiesService>();
  final Advertisement? advertisement;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    if (advertisement != null) {
      controller.firstTimePopulateAdImages(advertisement!);
      controller.initFileds(advertisement!);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditMode ? 'تعديل اعلان' : 'اعلان جديد',
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomContainer(
                  title: 'معلومات السيارة',
                  children: [
                    CustomSearchableDropdown<String>(
                      info: 'السنة',
                      items: controller.yearDropdownItems,
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedYear = value;
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      initialValue: controller.selectedYear,
                    ),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'الماركة',
                      items: utilitiesService.makes
                          .map((e) => e.label['ar'] ?? '')
                          .toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedMake = value;

                        final selectedKey = utilitiesService.makes
                            .firstWhere((e) => e.label['ar'] == value)
                            .id
                            .toString();

                        controller.selectedMakeID = selectedKey;
                        controller.clearModelFiled();
                      },
                      // initialValue: controller.selectedMake,
                      hint: controller.selectedMake,
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<NewAdController>(
                        id: 'model',
                        builder: (controller) {
                          // print(controller.selectedModel);
                          return CustomSearchableDropdown<Make>(
                            info: 'المودل',
                            fetchItems: (filter) async {
                              var allItems = await controller
                                  .fetchModels(controller.selectedMakeID ?? '');
                              var items = allItems
                                  .where((item) => (item.label['ar'] ?? '')
                                      .toLowerCase()
                                      .contains(filter?.toLowerCase() ?? ''))
                                  .toList();
                              return items;
                            },
                            itemAsString: (make) => make.label['ar']!,
                            onChanged: (selectedMake) {
                              controller.selectedModel =
                                  selectedMake?.label['ar'];
                              // print(
                              //     "selected make: ${selectedMake?.name} || id: ${selectedMake?.id}");
                              controller.selectedModelID =
                                  selectedMake?.id.toString();
                            },
                            customFilterFn: (item, filter) {
                              return (item.label['ar'] ?? '')
                                  .toLowerCase()
                                  .contains(filter.toLowerCase());
                            },
                            hint: controller.selectedModel,
                          );
                        }),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'الوقود',
                      items:
                          MetaLabelOptions.fuelTypes.map((e) => e.ar).toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedFuelType = value;
                        // controller.selectedFuelType = MetaLabelOptions.fuelTypes
                        //     .firstWhere((element) => element.ar == value)
                        //     .en
                        //     .toLowerCase();
                      },
                      initialValue: controller.selectedFuelType,
                    ),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'ناقل الحركة',
                      items: MetaLabelOptions.transmissions
                          .map((e) => e.ar)
                          .toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedTransmission = value;
                        // controller.selectedTransmission = MetaLabelOptions
                        //     .transmissions
                        //     .firstWhere((element) => element.ar == value)
                        //     .en
                        //     .toLowerCase();
                      },
                      initialValue: controller.selectedTransmission,
                    ),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'نوع الهيكل',
                      items: utilitiesService.bodyTypes
                          .map((e) => e.name['ar'] ?? '')
                          .toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedBodyType = value;
                        // if (value != null) {
                        //   final selectedKey = utilitiesService.bodyTypes
                        //       .firstWhere((e) => e.name['ar'] == value)
                        //       .key;
                        //   controller.selectedBodyType = selectedKey;
                        // }
                      },
                      initialValue: controller.selectedBodyType,
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<NewAdController>(
                      builder: (controller) => CustomInputField(
                        info: 'عدد المقاعد',
                        textInputType: TextInputType.number,
                        controller: controller.seatsController,
                        // onChanged: (value) =>
                        //     controller.seatsController.text = value,
                        // initialValue: controller,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<NewAdController>(
                      builder: (controller) => CustomInputField(
                        info: 'عدد الأبواب',
                        textInputType: TextInputType.number,
                        // onChanged: (value) =>
                        //     controller.doorsController.text = value,
                        controller: controller.doorsController,
                        // initialValue: advertisement?.doors,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'لون الداخلية',
                      items: utilitiesService.interiorColors
                          .map((e) => e.name['ar'] ?? '')
                          .toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedInteriorColor = value;
                        // if (value != null) {
                        //   final selectedKey = utilitiesService.interiorColors
                        //       .firstWhere((e) => e.name['ar'] == value)
                        //       .key;
                        //   controller.selectedInteriorColor = selectedKey;
                        // }
                      },
                      initialValue: controller.selectedInteriorColor,
                    ),
                    const SizedBox(height: 16),
                    CustomSearchableDropdown<String>(
                      info: 'لون الخارجية',
                      items: utilitiesService.exteriorColors
                          .map((e) => e.name['ar'] ?? '')
                          .toList(),
                      itemAsString: (item) => item,
                      onChanged: (value) {
                        controller.selectedExteriorColor = value;
                        // if (value != null) {
                        //   final selectedKey = utilitiesService.exteriorColors
                        //       .firstWhere((e) => e.name['ar'] == value)
                        //       .key;
                        //   controller.selectedExteriorColor = selectedKey;
                        // }
                      },
                      initialValue: controller.selectedExteriorColor,
                    ),
                  ],
                ),
              ),
              CustomContainer(
                title: 'معلومات الإعلان',
                children: [
                  CustomInputField(
                    info: 'اسم الإعلان',
                    // onChanged: (value) =>
                    //     controller.adNameController.text = value,
                    controller: controller.adNameController,
                    minLines: 1,
                    maxLines: 1,
                    // initialValue: advertisement?.title,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    info: 'الوصف',
                    // onChanged: (value) =>
                    //     controller.descriptionController.text = value,
                    controller: controller.descriptionController,
                    minLines: 5,
                    maxLines: 15,
                    // initialValue: advertisement?.description,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    info: 'السعر (دولار امريكي)',
                    textInputType: TextInputType.number,
                    // onChanged: (value) =>
                    //     controller.priceController.text = value,
                    controller: controller.priceController,
                    // initialValue: advertisement?.price,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    info: 'الكيلومتراج',
                    textInputType: TextInputType.number,
                    // onChanged: (value) =>
                    //     controller.mileageController.text = value,
                    controller: controller.mileageController,
                    // initialValue: advertisement?.mileage,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    info: 'العنوان',
                    // onChanged: (value) =>
                    //     controller.addressController.text = value,
                    controller: controller.addressController,
                    maxLines: 1,
                    minLines: 1,
                    // initialValue: advertisement?.address,
                  ),
                  CustomSearchableDropdown<String>(
                    info: 'المقاطعة',
                    items: utilitiesService.provinces
                        .map((e) => e.name['ar'] ?? '')
                        .toList(),
                    itemAsString: (item) => item,
                    onChanged: (value) {
                      controller.selectedProvinc = value;
                      // if (value != null) {
                      //   final selectedKey = utilitiesService.provinces
                      //       .firstWhere((e) => e.name['ar'] == value)
                      //       .key;
                      //   controller.selectedProvinc = selectedKey;
                      // }
                    },
                    initialValue: controller.selectedProvinc,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<String>(
                    info: 'حالة السيارة',
                    items:
                        MetaLabelOptions.conditions.map((e) => e.ar).toList(),
                    itemAsString: (item) => item,
                    onChanged: (value) {
                      controller.selectedCarStatus = value;
                    },
                    initialValue: controller.selectedCarStatus,
                  ),
                ],
              ),
              Visibility(
                visible: advertisement == null,
                child: CustomContainer(
                  title: "الصور",
                  children: [
                    ImageSelector(
                      directUploadAfterSelection: isEditMode,
                      adID: advertisement?.id,
                    ),
                  ],
                ),
              ),
              Obx(
                () => Visibility(
                  visible:
                      controller.imageFiles.isNotEmpty || advertisement != null,
                  child: CustomContainer(
                    title: 'معاينة الصور',
                    children: [
                      advertisement == null
                          ? ImagePreview(
                              imageFiles: controller.imageFiles,
                              adID: null,
                            )
                          : GetBuilder<NewAdController>(
                              id: 'images_preview',
                              builder: (controller) {
                                return ImagePreview(
                                  imagePaths: controller.imageMedia
                                      .map((element) => element)
                                      .toList(),
                                  adID: advertisement!.id,
                                );
                              })
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 55),
              CustomBottomNavigationBar(
                title: isEditMode ? 'تعديل' : 'نشر',
                onPressed: () async {
                  isEditMode
                      ? await controller.editAd(advertisement!.id)
                      : await controller.submitAd();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
