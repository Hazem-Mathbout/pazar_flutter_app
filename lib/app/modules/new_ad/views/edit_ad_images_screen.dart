import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/modules/new_ad/controllers/edit_ad_images_controller.dart';
import 'package:pazar/app/modules/new_ad/widgets/image_selector.dart';
import 'package:pazar/app/shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_action_bottom_sheet.dart';

class EditAdImagesScreen extends StatelessWidget {
  EditAdImagesScreen({
    super.key,
    required this.useLocalFiles,
    required this.adID,
  });
  final bool useLocalFiles;
  final int? adID;
  final controller = Get.find<EditAdImagesController>();

  @override
  Widget build(BuildContext context) {
    controller.useLocalFiles = useLocalFiles;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomActionBottomSheet(
        onCancel: () => Get.back(),
        onSave: () {
          try {
            controller.saveFinalImagesEdit();
            Get.back();
          } catch (e) {
            Get.snackbar('خطأ', e.toString());
          }
        },
      ),
      appBar: const CustomAppBar(
        title: 'الصور',
        centerTitle: true,
      ),
      body: GetBuilder<EditAdImagesController>(
        id: 'images_preview',
        builder: (controller) {
          final images = controller.useLocalFiles
              ? controller.imageFiles
              : controller.imageMedia;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSelector(
                  directUploadAfterSelection: !controller.useLocalFiles,
                  adID: adID,
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: List.generate(images.length, (index) {
                    final imageWidget = controller.useLocalFiles
                        ? FileImage(controller.imageFiles[index])
                        : NetworkImage(controller.imageMedia[index].url)
                            as ImageProvider;

                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: imageWidget, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: PopupMenuButton<int>(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                  elevation: 0.0,
                                  position: PopupMenuPosition.under,
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.white,
                                  offset: const Offset(0, 4),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      onTap: () {
                                        controller.setAsMainImage(index);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.black54),
                                          SizedBox(width: 8),
                                          Text('تعيين كصورة رئيسية',
                                              style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      onTap: () =>
                                          controller.deleteImageAt(index),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('حذف',
                                              style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: Container(
                                    width: 32,
                                    height: 32,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.more_vert,
                                        size: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (index == 0)
                                Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.image,
                                          size: 16, color: Color(0xFF404040)),
                                      SizedBox(width: 4),
                                      Text("الصورة الرئيسية",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF404040))),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
