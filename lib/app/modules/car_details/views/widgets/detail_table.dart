import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class DetailTable extends StatelessWidget {
  final Map<String, dynamic> entries;
  final double rowSpacing;
  final String tableName;

  const DetailTable({
    required this.entries,
    required this.tableName,
    this.rowSpacing = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Ensures alignment
      children: [
        Text(
          tableName,
          style: const TextStyle(
            fontFamily: "Rubik", // Font family
            fontWeight: FontWeight.w500, // Matches font-weight: 500
            fontSize: 18, // Matches font-size: 18px
            height: 24 / 18, // Line-height conversion (24px / 18px)
            letterSpacing: 0, // Explicitly set to 0%
            textBaseline:
                TextBaseline.alphabetic, // Ensures proper vertical alignment
          ),
          textAlign: TextAlign.right, // Align text to the right
        ),
        const SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ensures alignment
          children: entries.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: rowSpacing),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items properly
                children: [
                  SizedBox(
                    width: 120, // Fixed width for key column
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontFamily: "Rubik", // Matches font-family: Rubik
                        fontWeight: FontWeight.w400, // Matches font-weight: 400
                        fontSize: 16, // Matches font-size: 16px
                        height:
                            20 / 16, // Line-height calculation (20px / 16px)
                        letterSpacing: 0, // Explicitly setting to 0
                        color: AppColors.foregroundSecondary,
                      ),
                      textAlign: TextAlign.right, // Align key text to the right
                    ),
                  ),
                  const SizedBox(width: 12), // Space between key and value
                  SizedBox(
                    width:
                        150, // Fixed width for value column (adjust as needed)
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontFamily: "Rubik", // Matches font-family: Rubik
                        fontWeight: FontWeight.w400, // Matches font-weight: 400
                        fontSize: 16, // Matches font-size: 16px
                        height: 20 /
                            16, // Line-height calculation (20px / 16px = 1.25)
                        letterSpacing: 0, // Matches letter-spacing: 0%
                        color: AppColors
                            .foregroundPrimary, // Keeps the existing color
                      ),
                      textAlign:
                          TextAlign.right, // Align value text to the left
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
