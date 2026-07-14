import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../manager/otp/otp_cubit.dart';
import '../manager/otp/otp_state.dart';

class ResendButton extends StatelessWidget {
  const ResendButton({
    super.key,
    required this.formatTime}) ;

  final String Function(int) formatTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, state) {
        if (state.canResend) {
          return AppTextButton(
            label: 'Resend code',
            onPressed: context.read<OtpCubit>().resendCode,
          );
        }
        return Text.rich(
          TextSpan(
            style: AppTextStyles.subtitle,
            children: [
              const TextSpan(text: 'Resend in '),
              TextSpan(
                text: formatTime(state.secondsRemaining),
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
