import 'package:flutter/cupertino.dart';

import '../../../../Core/Widgets/CustomTextForm.dart';

class MotorcycleInput extends StatelessWidget {
  const MotorcycleInput({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?, String) validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      controller: controller,
      labelText: label,
      prefixIcon: icon,
      validator: (value) => validator(value, label),
    );
  }
}
