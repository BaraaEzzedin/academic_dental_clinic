import 'package:academic_dental_clinic/core/service_locator/auth_service.dart';
import 'package:academic_dental_clinic/core/utils/app_validator.dart';
import 'package:academic_dental_clinic/features/auth/presentation/widgets/resend_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import '../manager/otp/otp_cubit.dart';
import '../manager/verify_otp/verify_otp_cubit.dart';
import '../manager/verify_otp/verify_otp_state.dart';
import '../widgets/otp_field.dart';
import 'patient_home.dart';


class OtpVerification extends StatefulWidget {
  const OtpVerification({
    super.key,
    this.phoneNumber = '09XXXXXXXX',
    this.codeLength = 6,
  });

  final String phoneNumber;
  final int codeLength;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();



  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _onVerify(BuildContext context) {
    _codeFocusNode.unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    context.read<VerifyOtpCubit>().verifyOtp(
      phone: widget.phoneNumber,
      code: _codeController.text.trim(),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpCubit>(
          create: (_) => OtpCubit(),
        ),
        BlocProvider<VerifyOtpCubit>(
          create: (_) => VerifyOtpCubit(sl<VerifyOtpUseCase>()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is VerifyOtpSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => PatientHome(user: state.user),
                  ),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is VerifyOtpLoading;
              return Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenHorizontalPadding,
                          vertical: AppDimensions.xxl,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 100,),
                            Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.primary,
                              size: 80,
                            ),
                            const SizedBox(height: AppDimensions.xxl),
                            const Text('Verify Your Phone Number'),
                            const SizedBox(height: AppDimensions.md),
                            Text.rich(
                              TextSpan(
                                style: AppTextStyles.subtitle,
                                children: [
                                  TextSpan(
                                    text: 'Enter the ${widget.codeLength}-digit '
                                        'code sent to ',
                                  ),
                                  TextSpan(
                                    text: widget.phoneNumber,
                                    style: AppTextStyles.subtitle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.xxl),
                            Form(
                              key: _formKey,
                              child: OtpField(
                                length: widget.codeLength,
                                controller: _codeController,
                                focusNode: _codeFocusNode,
                                autofocus: true,
                                validator: AppValidator.validateOtp,
                                onCompleted: (_) => _onVerify(context),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.xxl),
                            ResendButton(formatTime: _formatTime),
                            const SizedBox(height: AppDimensions.xxl),
                            AppPrimaryButton(
                              label: 'Verify & Continue',
                              trailingIcon: Icons.arrow_forward,
                              onPressed:
                                  isLoading ? null : () => _onVerify(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black26,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}