import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';

class UniversityIdField extends StatelessWidget {
  const UniversityIdField({
    super.key,
    required this.controller,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'University ID',
      controller: controller,
      hintText: 'UD-123456',
      prefixIcon: Icons.school_outlined,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      validator: validator,
    );
  }
}