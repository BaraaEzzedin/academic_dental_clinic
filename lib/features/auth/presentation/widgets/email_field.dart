import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_text_field.dart';

class EmailField extends StatelessWidget {
  const EmailField({
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
      label: 'Email',
      controller: controller,
      hintText: 'name@example.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      validator: validator,
    );
  }
}