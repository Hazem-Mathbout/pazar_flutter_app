import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InternationalPhoneInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String label;

  const InternationalPhoneInput({
    super.key,
    this.initialValue,
    this.onChanged,
    required this.label,
  });

  @override
  State<InternationalPhoneInput> createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  late TextEditingController _controller;
  final bool _isExternalController = false;
  late FocusNode _focusNode;
  CountryCode _countryCode = CountryCode.fromCountryCode('SY');
  bool _isActive = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isActive = _focusNode.hasFocus;
      });
    });

    // Always parse the number ONCE (even with external controller)
    _parseInitialValue();
  }

  void _parseInitialValue() {
    final value = widget.initialValue ?? _controller.text;

    if (value.startsWith('+')) {
      for (var code in codes) {
        if (value.startsWith('${code.dialCode}')) {
          _countryCode = code;

          final numberWithoutCode = value.replaceFirst('${code.dialCode}', '');
          // Avoid triggering controller listener if external
          if (!_isExternalController) {
            _controller.text = numberWithoutCode;
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.text = numberWithoutCode;
            });
          }
          break;
        }
      }
    } else {
      if (!_isExternalController) {
        _controller.text = value;
      }
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    final fullNumber = '${_countryCode.dialCode}${_controller.text}';
    widget.onChanged?.call(fullNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.14,
              letterSpacing: 0.0,
            ),
          ),
        ),

        /// Styled TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _isActive ? const Color(0xFFDC2626) : const Color(0xFFE5E5E5),
            ),
            boxShadow: _isActive
                ? [
                    const BoxShadow(
                      color: Color(0x66DC2626),
                      spreadRadius: 3,
                      blurRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _notifyChanged(),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              border: InputBorder.none,
              hintText: 'XXX XXX XXX',
              prefixIcon: CountryCodePicker(
                onChanged: (CountryCode code) {
                  setState(() => _countryCode = code);
                  _notifyChanged();
                },
                initialSelection: _countryCode.code,
                favorite: const ['SY', 'SA', 'AE', 'EG'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                padding: EdgeInsets.zero,
                showFlag: true,
                showFlagDialog: true,
                flagWidth: 24,
                flagDecoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                comparator: (a, b) => b.name!.compareTo(a.name!),
                builder: (code) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (code?.flagUri != null)
                        Image.asset(
                          code!.flagUri!,
                          package: 'country_code_picker',
                          width: 24,
                          height: 16,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        code?.dialCode ?? '+963',
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper: List of all supported country codes
final List<CountryCode> codes = [
  CountryCode.fromCountryCode('SY'),
  CountryCode.fromCountryCode('SA'),
  CountryCode.fromCountryCode('AE'),
  CountryCode.fromCountryCode('EG'),
  // Add more if needed
];
