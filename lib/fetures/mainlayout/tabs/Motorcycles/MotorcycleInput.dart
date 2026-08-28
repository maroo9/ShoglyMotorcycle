import 'package:flutter/material.dart';

import '../../../../Core/Widgets/CustomTextForm.dart';

class MotorcycleInput extends StatelessWidget {
  const MotorcycleInput({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?, String) validator;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      controller: controller,
      labelText: label,
      prefixIcon: icon,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) => validator(value, label),
    );
  }
}
