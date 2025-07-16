import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/utilities_models.dart';

class PageDetailScreen extends StatelessWidget {
  final PageItem page;

  const PageDetailScreen({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(page.title.ar),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'إغلاق',
            onPressed: () => Get.back(),
            color: AppColors.foregroundSecondary,
          ),
        ],
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 24 / 18,
          color: Color(0xFF171717),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the border
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: page.body.ar, // Using flutter_html package for HTML content
        ),
      ),
    );
  }
}
