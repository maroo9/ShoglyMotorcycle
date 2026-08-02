import 'package:flutter/cupertino.dart';

import '../../../../Core/Widgets/CustomTextForm.dart';

class RepresentativeInput extends StatelessWidget {
  const RepresentativeInput({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?, String) validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      controller: controller,
      labelText: label,
      prefixIcon: icon,
      keyboardType: keyboardType,
      validator: (value) => validator(value, label),
    );
  }
}