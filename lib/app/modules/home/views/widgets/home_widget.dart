import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/routes/app_pages.dart';

class HomeWidget extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'label': 'سيارات', 'icon': '🚗'},
    {'label': 'معدات ثقيلة', 'icon': '🏗️'},
    {'label': 'معدات زراعية', 'icon': '🌾'},
    {'label': 'دراجات نارية', 'icon': '🏍️'},
    {'label': 'أجزاء السيارات', 'icon': '🧩'},
    {'label': 'خدمات', 'icon': '🛠️'},
  ];

  HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // Search bar and notification icon
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'بحث عن عقار للإيجار',
                      prefixIcon: const Icon(
                        Icons.apartment,
                        color: AppColors.foregroundBrand,
                      ), // Changed to apartment icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    size: 30,
                    color: AppColors.foregroundSecondary,
                  ),
                  onPressed: () {
                    // handle notification
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Grid of categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.CARS),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['icon']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['label']!,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Blue verified banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Verified icon
                  const Icon(Icons.verified, color: Colors.blue),
                  const SizedBox(width: 12),
                  // Text content
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('حصلت على شارة مستخدم معتمد',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('احصل على عدد مشاهدات أكثر لإعلاناتك',
                            style: TextStyle(fontSize: 12)),
                        Text(
                          'مصداقية أكبر',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Flipped arrow icon
                  Transform(
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0), // Flips horizontally
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section title
            const Text(
              'ما الجديد على دويزل',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Horizontal list
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPromoCard('العقارات', 'اكتشف المشاريع الجديدة'),
                  const SizedBox(width: 12),
                  _buildPromoCard('العقارات', 'تواصل مع الوكلاء'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String label, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 120,
          padding: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://upcdn.io/FW25b3d/raw/uploads/2023/04/18/file-6h8s.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Chip(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              label: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Transform(
                transform: Matrix4.identity()
                  ..scale(-1.0, 1.0), // Flips horizontally
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            )
          ],
        )
      ],
    );
  }
}
