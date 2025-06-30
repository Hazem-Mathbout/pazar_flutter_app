import 'package:flutter/material.dart';
import 'package:pazar/app/shared/widgets/custom_action_bottom_sheet.dart';

void showReportDialog(
  BuildContext context,
  Function(String reason, String description) onSubmit,
) {
  final List<Map<String, String>> reasons = [
    {'value': 'spam', 'label': 'رسائل مزعجة'},
    {'value': 'fraud', 'label': 'احتيال'},
    {'value': 'inappropriate', 'label': 'محتوى غير لائق'},
    {'value': 'wrong_info', 'label': 'معلومات غير صحيحة'},
    {'value': 'other', 'label': 'أخرى'},
  ];

  String? selectedReason;
  TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('تبليغ عن إعلان'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('اختر سبب التبليغ'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                hint: const Text('اختر السبب'),
                items: reasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason['value'],
                    child: Text(reason['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedReason = value;
                },
              ),
              const SizedBox(height: 16),
              const Text('الوصف (إجباري)'),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اكتب تفاصيل إضافية هنا...',
                ),
              ),
              const SizedBox(height: 24),
              CustomActionBottomSheet(
                padding: const EdgeInsets.all(0),
                isSaveExpanded: true,
                saveText: 'إرسال التبليغ',
                cancelText: 'إلغاء',
                showBorder: false,
                onCancel: () => Navigator.of(context).pop(),
                onSave: () async {
                  if (selectedReason == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('الرجاء اختيار سبب التبليغ.')),
                    );
                    return;
                  }

                  if (descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('الرجاء كتابة وصف للتبليغ.')),
                    );
                    return;
                  }

                  Navigator.of(context).pop(); // Close the dialog

                  await onSubmit(
                    selectedReason!,
                    descriptionController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
