import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/shared/widgets/scrollable_text_area.dart';

class CustomInputField extends StatefulWidget {
  final String info;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final TextEditingController? controller;
  final Function(String)? onChanged; // Add onChanged parameter
  final String? initialValue; // New parameter for initial value
  final TextInputType? textInputType;
  final int? minLines;
  final int? maxLines;
  final TextDirection? textDirection;

  const CustomInputField({
    super.key,
    required this.info,
    this.isDropdown = false,
    this.dropdownItems,
    this.controller,
    this.onChanged, // Initialize the onChanged parameter
    this.initialValue, // Initialize the initialValue parameter
    this.textInputType,
    this.minLines,
    this.maxLines = 1,
    this.textDirection,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool isActive = false;
  String? selectedValue;
  late FocusNode _focusNode; // Declare the FocusNode
  // Initialise a scroll controller.
  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize the FocusNode
    _focusNode.addListener(() {
      setState(() {
        isActive = _focusNode.hasFocus;
      });
    });

    // Set the initial selectedValue for the dropdown or controller value
    // if (widget.isDropdown) {
    //   selectedValue =
    //       widget.initialValue ?? ''; // Empty string to show hint ('اختر')
    // } else if (widget.controller != null) {
    //   widget.controller?.text = widget.initialValue ?? '';
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label Text
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.info,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.14,
              letterSpacing: 0.0,
            ),
          ),
        ),

        /// Input Box
        GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .requestFocus(_focusNode); // Request focus when tapped
          },
          child: Container(
            // height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            clipBehavior: Clip.hardEdge,
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
            child: widget.isDropdown
                ? DropdownButtonFormField<String>(
                    focusNode:
                        _focusNode, // Assign the FocusNode to the DropdownButton
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                      ), // Control vertical padding
                    ),
                    value: selectedValue!.isEmpty
                        ? null
                        : selectedValue, // Set null for hint visibility
                    elevation: 0,
                    hint: const Text(
                      "اختر",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 16 /
                            14, // Ensure this is not causing an undesired height
                        color: Color(0xFFA3A3A3),
                      ),
                    ),
                    items: widget.dropdownItems
                        ?.map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedValue = value);
                      if (widget.onChanged != null) {
                        widget
                            .onChanged!(value!); // Call the onChanged callback
                      }
                    },
                    icon: Image.asset(
                      'assets/icons/selector.png',
                      height: 16,
                      width: 16,
                      color: AppColors.foregroundHint,
                    ),
                    iconSize: 16,
                    isExpanded: true,
                    isDense: true, // Ensures dense layout for proper alignment
                  )
                : ScrollableTextArea(
                    controller: widget.controller,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    textInputType: widget.textInputType,
                    onChanged: widget.onChanged,
                    focusNode: _focusNode,
                    textDirection: widget.textDirection,
                  ),
          ),
        ),
      ],
    );
  }
}
