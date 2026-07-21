import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../manager/case_details/case_details_cubit.dart';
import '../manager/case_details/case_details_state.dart';
import '../models/case_details.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/diagnostic_media_card.dart';
import '../widgets/patient_case_header_card.dart';
import '../widgets/progress_timeline_card.dart';
import '../widgets/supervisor_notes_card.dart';
import '../widgets/treatment_plan_summary_card.dart';
import 'dental_chart_screen.dart';

class CaseDetailsScreen extends StatelessWidget {
  const CaseDetailsScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CaseDetailsCubit>(
      create: (_) => CaseDetailsCubit()..load(patientId),
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
                child: CaseDetailsTopBar(),
              ),
              Expanded(
                child: BlocBuilder<CaseDetailsCubit, CaseDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (state.status == CaseDetailsStatus.error ||
                        state.details == null) {
                      return ErrorView(
                        message: state.errorMessage ??
                            'Could not load case details.',
                        onRetry: () =>
                            context.read<CaseDetailsCubit>().load(patientId),
                      );
                    }
                    return CaseDetailsBody(details: state.details!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaseDetailsBody extends StatelessWidget {
  const CaseDetailsBody({ super.key ,required this.details});

  final CaseDetails details;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        PatientCaseHeaderCard(details: details),
        const SizedBox(height: AppDimensions.lg),
        TreatmentPlanSummaryCard(
          rows: details.planRows,
          materials: details.materials,
          onViewDentalChart: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DentalChartScreen(records: details.dentalChart),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.lg),
        ProgressTimelineCard(
          phases: details.phases,
          onViewDetails: () {
            // TODO: navigate to the full progress details screen.
          },
        ),
        const SizedBox(height: AppDimensions.lg),
        DiagnosticMediaCard(media: details.media),
        const SizedBox(height: AppDimensions.lg),
        SupervisorNotesCard(notes: details.notes),
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({ super.key ,required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppDimensions.lg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}