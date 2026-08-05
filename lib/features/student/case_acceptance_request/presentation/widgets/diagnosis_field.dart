import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_text_field.dart';

class DiagnosisField extends StatelessWidget {
  const DiagnosisField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Diagnosis',
      hintText: 'Describe the clinical diagnosis for this case…',
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 4,
      maxLines: 7,
      onChanged: onChanged,
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'Diagnosis is required.'
          : null,
    );
  }
}