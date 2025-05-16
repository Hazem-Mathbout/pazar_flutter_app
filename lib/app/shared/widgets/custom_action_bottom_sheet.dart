import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';

import 'primary_button.dart';

class CustomActionBottomSheet extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool isSaveExpanded;
  final bool showBorder;
  final String saveText;
  final String cancelText;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const CustomActionBottomSheet({
    super.key,
    this.padding = const EdgeInsets.all(16.0),
    this.saveText = 'حفظ التعديلات',
    this.cancelText = 'تجاهل',
    this.isSaveExpanded = true,
    this.showBorder = false,
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBorder
            ? const Border(
                top: BorderSide(
                  color: AppColors.borderDefault,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Cancel / Ignore Button
          ElevatedButton(
            onPressed: onCancel ?? () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundDefault,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            child: Text(
              cancelText,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.foregroundSecondary,
                letterSpacing: 0.0,
                height: 20 / 16,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Save Button (optionally expanded)
          isSaveExpanded
              ? Expanded(
                  child: _buildSaveButton(),
                )
              : _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return PrimaryButton(
      text: saveText,
      onPressed: onSave ?? () => Get.back(),
    );
  }
}
