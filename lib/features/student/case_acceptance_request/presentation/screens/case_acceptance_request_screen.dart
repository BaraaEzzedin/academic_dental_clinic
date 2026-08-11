import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../home/presentation/screens/main_screen.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/use_cases/get_subject_configuration_use_case.dart';
import '../../domain/use_cases/submit_case_acceptance_request_use_case.dart';
import '../manager/case_acceptance_request/case_acceptance_request_cubit.dart';
import '../manager/case_acceptance_request/case_acceptance_request_state.dart';
import '../models/case_acceptance_request_args.dart';
import '../widgets/case_acceptance_request_content.dart';

class CaseAcceptanceRequestScreen extends StatelessWidget {
  const CaseAcceptanceRequestScreen({super.key, required this.args});

  final CaseAcceptanceRequestArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CaseAcceptanceRequestCubit>(
      create: (_) => CaseAcceptanceRequestCubit(
        getSubjectConfiguration: sl<GetSubjectConfigurationUseCase>(),
        submitAcceptanceRequest: sl<SubmitCaseAcceptanceRequestUseCase>(),
        args: args,
      )..loadConfiguration(),
      child: Scaffold(
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
                child: CaseDetailsTopBar(title: 'Case Acceptance Request'),
              ),
              Expanded(
                child: BlocListener<CaseAcceptanceRequestCubit,
                    CaseAcceptanceRequestState>(
                  listenWhen: (previous, current) =>
                      previous.submission != current.submission,
                  listener: _onSubmissionChanged,
                  child: CaseAcceptanceRequestContent(args: args),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmissionChanged(
    BuildContext context,
    CaseAcceptanceRequestState state,
  ) {
    switch (state.submission) {
      case RequestSubmission.success:
        _showSnack(
          context,
          message: 'Acceptance request sent to your supervisor.',
          icon: Icons.check_circle_rounded,
          background: AppColors.success,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const MainScreen()),
          (route) => false,
        );
      case RequestSubmission.failure:
        _showSnack(
          context,
          message: state.submissionError ??
              'Could not send the request. Please try again.',
          icon: Icons.error_outline_rounded,
          background: AppColors.error,
        );
      case RequestSubmission.idle:
      case RequestSubmission.submitting:
        break;
    }
  }

  void _showSnack(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color background,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
  }
}