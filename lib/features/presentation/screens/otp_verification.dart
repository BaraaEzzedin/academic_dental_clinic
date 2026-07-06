import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Text("OTP"),
      ),
    );
  }
}
