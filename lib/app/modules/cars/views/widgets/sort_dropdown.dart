import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class SortDropdown extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const SortDropdown({super.key, this.initialValue, this.onChanged});

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  String? _selectedValue;
  final LayerLink _layerLink = LayerLink();

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'lowest_first',
      'label': 'السعر: الاقل اولاً',
      'icon': Icons.arrow_downward,
    },
    {
      'value': 'priceHighToLow',
      'label': 'السعر: الاعلى اولاً',
      'icon': Icons.arrow_upward,
    },
    {
      'value': 'newest',
      'label': 'التاريخ: الأحدث',
      'icon': Icons.access_time,
    },
    {
      'value': 'oldest',
      'label': 'التاريخ: الأقدم',
      'icon': Icons.history,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? 'lowest_first';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () => _showMenu(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.mediumGrey),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _options.firstWhere(
                  (opt) => opt['value'] == _selectedValue,
                  orElse: () => _options.first,
                )['label'],
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                  color: AppColors.semiTransparentBlack,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/icons/chevron-down.png',
                height: 16,
                width: 16,
                color: AppColors.foregroundSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: _options.map((option) {
        final isSelected = _selectedValue == option['value'];
        return PopupMenuItem<String>(
          value: option['value'],
          child: Row(
            children: [
              Icon(
                option['icon'],
                size: 20,
                color: isSelected
                    ? AppColors.primaryRed // Red color for selected
                    : AppColors.foregroundSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                option['label'],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  color: isSelected
                      ? AppColors.primaryRed // Red color for selected
                      : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      elevation: 0, // Remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.mediumGrey),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => _selectedValue = value);
        widget.onChanged?.call(value);
      }
    });
  }
}
