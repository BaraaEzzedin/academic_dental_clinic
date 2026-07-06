import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.validator,
    this.autofocus = false,
  });

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final FormFieldValidator<String>? validator;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.radiusMd);

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 54,
      textStyle: AppTextStyles.otpDigit,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: radius,
        border: Border.all(color: AppColors.fieldBorder),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: radius,
      border: Border.all(color: AppColors.primary, width: 1.5),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: radius,
      border: Border.all(color: AppColors.primary),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: radius,
      border: Border.all(color: AppColors.error),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onCompleted: onCompleted,
      validator: validator,
      keyboardType: TextInputType.number,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
    );
  }
}