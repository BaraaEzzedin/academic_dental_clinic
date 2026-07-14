import 'package:academic_dental_clinic/core/service_locator/auth_service.dart';
import 'package:academic_dental_clinic/core/utils/app_validator.dart';
import 'package:academic_dental_clinic/core/widgets/app_primary_button.dart';
import 'package:academic_dental_clinic/features/presentation/screens/otp_verification.dart';
import 'package:academic_dental_clinic/features/presentation/screens/patient_register.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/or_divider.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../manager/request_otp/request_otp_cubit.dart';
import '../manager/request_otp/request_otp_state.dart';
import '../widgets/logo_section.dart';

class PatientLogin extends StatefulWidget {
  const PatientLogin({super.key});

  @override
  State<PatientLogin> createState() => _PatientLoginState();

}

class _PatientLoginState extends State<PatientLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }


  void _onSendVerificationCode(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<RequestOtpCubit>().requestOtp(
      phone: _phoneNumberController.text.trim(),
    );
  }

  void _onRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PatientRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestOtpCubit>(
      create: (_) => RequestOtpCubit(sl<RequestOtpUseCase>()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocConsumer<RequestOtpCubit, RequestOtpState>(
            listener: (context, state) {
              if (state is RequestOtpFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is RequestOtpSuccess) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OtpVerification(phoneNumber: state.phone),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is RequestOtpLoading;
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontalPadding,
                      vertical: AppDimensions.xxl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: AppDimensions.lg,
                          ),
                          const LogoSection(),
                          const SizedBox(
                            height: AppDimensions.xl,
                            width: AppDimensions.maxContentWidth,
                          ),
                          Text("Welcome Back", style: AppTextStyles.welcome),
                          SizedBox(height: 5,),
                          Text(
                            "Sign in to access your account ",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.loginText,
                          ),
                          const SizedBox(height: AppDimensions.xxl),
                          const SizedBox(height: AppDimensions.xl),
                          PhoneNumberField(
                            controller: _phoneNumberController,
                            validator: AppValidator.validatePatientNumber,
                          ),
                          SizedBox(height: AppDimensions.xxl,),
                          AppPrimaryButton(
                            label: "SEND VERIFICATION CODE",
                            trailingIcon: Icons.chevron_right,
                            onPressed: isLoading
                                ? null
                                : () => _onSendVerificationCode(context),
                          ),
                          SizedBox(height: AppDimensions.xxl,),
                          OrDivider(),
                          SizedBox(height: AppDimensions.md,),
                          Center(
                            child: AppTextButton(
                              label: 'Register as a new patient ?',
                              onPressed: _onRegister,
                            ),
                          ),
                        ],
                      ),
                    ),
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