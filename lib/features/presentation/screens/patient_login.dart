import 'package:academic_dental_clinic/core/utils/app_validator.dart';
import 'package:academic_dental_clinic/core/widgets/app_primary_button.dart';
import 'package:academic_dental_clinic/features/presentation/screens/otp_verification.dart';
import 'package:academic_dental_clinic/features/presentation/screens/patient_register.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/or_divider.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/phone_number_field.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/app_text_button.dart';
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


  void _onSendVerificationCode() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OtpVerification()),
    );

  }

  void _onRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PatientRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
            child: SingleChildScrollView(
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
                const SizedBox(height: AppDimensions.xl, width: AppDimensions.maxContentWidth ,),
                    Text("Welcome Back" , style: AppTextStyles.welcome),
                    SizedBox(height: 5,),
                    Text("Sign in to access your account " , textAlign: TextAlign.center,
                        style: AppTextStyles.loginText
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                    const SizedBox(height: AppDimensions.xl),
                    PhoneNumberField(controller: _phoneNumberController , validator: AppValidator.validatePatientNumber,),
                    SizedBox(height: AppDimensions.xxl,),
                    AppPrimaryButton(label: "SEND VERIFICATION CODE", trailingIcon:  Icons.chevron_right ,onPressed: _onSendVerificationCode),
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
        ),
    );
  }
}
