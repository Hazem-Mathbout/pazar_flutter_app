import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';

class ScrollableTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextDirection? textDirection;

  const ScrollableTextArea({
    super.key,
    required this.controller,
    this.maxLines,
    this.minLines,
    this.textInputType = TextInputType.multiline,
    this.onChanged,
    this.focusNode,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines != null && maxLines! > 1;
    final scrollController = ScrollController();
    final node = focusNode ?? FocusNode();

    final textField = TextField(
      controller: controller,
      focusNode: node,
      textDirection: textDirection,
      scrollController: isMultiline ? scrollController : null,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: textInputType,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black,
      ),
      cursorColor: AppColors.foregroundHint,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );

    return isMultiline
        ? Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            thickness: 5.0,
            trackVisibility: true,
            radius: const Radius.circular(12),
            child: textField,
          )
        : textField;
  }
}
