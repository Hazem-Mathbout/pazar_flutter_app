import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class CustomRadioSelection<T> extends StatefulWidget {
  final String info;
  final List<T> items;
  final String Function(T)? itemAsString;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final String? hint;
  final bool showDragHandle;

  const CustomRadioSelection({
    super.key,
    required this.info,
    required this.items,
    this.itemAsString,
    this.initialValue,
    this.onChanged,
    this.hint,
    this.showDragHandle = true,
  });

  @override
  State<CustomRadioSelection<T>> createState() =>
      _CustomRadioSelectionState<T>();
}

class _CustomRadioSelectionState<T> extends State<CustomRadioSelection<T>> {
  bool isActive = false;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  void _showRadioSelectionSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isActive = true);

    // Calculate the needed height based on item count
    final itemCount = widget.items.length;
    const itemHeight = 56.0; // Approximate height of each RadioListTile
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    const paddingHeight = 100.0; // Height for header and other elements
    final calculatedHeight =
        (itemCount * itemHeight + paddingHeight).clamp(200.0, maxHeight);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: calculatedHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // iOS-style drag handle
              if (widget.showDragHandle)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),

              // Sheet header
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 16,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.info,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[300]),

              // Radio options - Flexible to allow scrolling when needed
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: calculatedHeight < maxHeight
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final label = widget.itemAsString != null
                        ? widget.itemAsString!(item)
                        : item.toString();

                    return RadioListTile<T>(
                      title: Text(label),
                      value: item,
                      groupValue: _selectedItem,
                      onChanged: (value) {
                        setState(() => _selectedItem = value);
                        widget.onChanged?.call(value);
                        Navigator.pop(context);
                      },
                      activeColor: AppColors.foregroundBrand,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) => setState(() => isActive = false));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.info,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.14,
            ),
          ),
        ),

        // Selection box
        GestureDetector(
          onTap: () => _showRadioSelectionSheet(context),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFE5E5E5),
              ),
              boxShadow: isActive
                  ? [
                      const BoxShadow(
                        color: Color(0x66DC2626),
                        spreadRadius: 3,
                        blurRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedItem != null
                          ? widget.itemAsString != null
                              ? widget.itemAsString!(_selectedItem as T)
                              : _selectedItem.toString()
                          : widget.hint ?? 'اختر',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: _selectedItem != null
                            ? FontWeight.bold
                            : FontWeight.w400,
                        fontSize: 12,
                        color: _selectedItem != null
                            ? Colors.black
                            : const Color(0xFFA3A3A3),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icons/selector.png',
                    height: 16,
                    width: 16,
                    color: AppColors.foregroundHint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
