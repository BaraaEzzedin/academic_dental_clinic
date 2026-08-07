import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../open_case_appointment/presentation/widgets/appointment_sheet.dart';
import '../../../open_case_appointment/presentation/widgets/appointment_summary_dialog.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/entities/open_case_details_entity.dart';
import '../../domain/entities/open_case_entity.dart';
import '../../domain/use_cases/get_open_case_details_use_case.dart';
import '../manager/open_case_details/open_case_details_cubit.dart';
import '../manager/open_case_details/open_case_details_state.dart';
import '../widgets/open_case_details_content.dart';
import '../widgets/open_case_details_empty_view.dart';
import '../widgets/open_case_details_shimmer.dart';


class OpenCaseDetailsScreen extends StatelessWidget {
  const OpenCaseDetailsScreen({super.key, required this.openCase});

  final OpenCaseEntity openCase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpenCaseDetailsCubit>(
      create: (_) =>
          OpenCaseDetailsCubit(sl<GetOpenCaseDetailsUseCase>())
            ..load(openCase.id),
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
                child: CaseDetailsTopBar(title: 'Open Case Details'),
              ),
              Expanded(
                child: BlocBuilder<OpenCaseDetailsCubit, OpenCaseDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const OpenCaseDetailsShimmer();
                    }
                    if (state.hasError) {
                      return ErrorRetryView(
                        message: state.errorMessage ??
                            'Could not load case details.',
                        onRetry: () => context
                            .read<OpenCaseDetailsCubit>()
                            .load(openCase.id),
                      );
                    }
                    final details = state.details;
                    if (details == null) {
                      return const OpenCaseDetailsEmptyView();
                    }
                    return OpenCaseDetailsContent(
                      details: details,
                      onStartExamination: () =>
                          _onStartExamination(context, details),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onStartExamination(
    BuildContext context,
    OpenCaseDetailsEntity details,
  ) async {
    final result = await showAppointmentSheet(context);
    if (result == null || !context.mounted) return;
    await showAppointmentSummaryDialog(
      context,
      result: result,
      patientName: details.patientName,
      subject: details.subject,
    );
  }
}