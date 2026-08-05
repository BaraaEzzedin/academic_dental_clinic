import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_stepper.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  static const List<String> _steps = [
    'Patient Data',
    'Case Description',
    'Send Request',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontalPadding,
                AppDimensions.lg,
                AppDimensions.screenHorizontalPadding,
                AppDimensions.lg,
              ),
              child: CaseDetailsTopBar(title: 'Add Patient'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontalPadding,
                vertical: AppDimensions.sm,
              ),
              // TODO: drive `currentStep` from the flow's state as the user
              // moves between the step screens.
              child: AppStepper(
                currentStep: 0,
                titles: _steps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}