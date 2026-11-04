import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Numeric text field used by onboarding and the profile editor.
///
/// Keeping one widget guarantees both screens apply the same keyboard type,
/// length limits and decimal rules, so a value accepted during setup is also
/// accepted later.
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    this.suffix,
    this.hint,
    this.allowDecimal = false,
    this.onChanged,
    super.key,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String? suffix;
  final String? hint;
  final bool allowDecimal;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      inputFormatters: allowDecimal
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,3}(\.\d{0,1})?'),
              ),
            ]
          : <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
      ),
    );
  }
}
