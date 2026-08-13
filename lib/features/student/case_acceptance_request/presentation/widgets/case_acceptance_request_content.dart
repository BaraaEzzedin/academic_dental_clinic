import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/procedure_request_entity.dart';
import '../manager/case_acceptance_request/case_acceptance_request_cubit.dart';
import '../manager/case_acceptance_request/case_acceptance_request_state.dart';
import '../models/case_acceptance_request_args.dart';
import 'add_procedure_card.dart';
import 'case_acceptance_request_shimmer.dart';
import 'dental_chart_card.dart';
import 'patient_summary_card.dart';
import 'procedure_picker_sheet.dart';
import 'selected_procedures_section.dart';

class CaseAcceptanceRequestContent extends StatelessWidget {
  const CaseAcceptanceRequestContent({super.key, required this.args});

  final CaseAcceptanceRequestArgs args;

  void _openPicker(
    BuildContext context, {
    int? toothNumber,
    ProcedureRequestEntity? existing,
  }) {
    final cubit = context.read<CaseAcceptanceRequestCubit>();
    showProcedurePickerSheet(
      context,
      procedures: cubit.state.procedures,
      questions: cubit.state.questions,
      onSave: cubit.saveProcedureRequest,
      toothNumber: toothNumber,
      existing: existing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
      buildWhen: (p, c) => p.configStatus != c.configStatus,
      builder: (context, state) {
        if (state.isLoadingConfig) {
          return const CaseAcceptanceRequestShimmer();
        }
        if (state.hasConfigError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: ErrorRetryView(
                message:
                    state.configError ?? 'Could not load the subject details.',
                onRetry: () => context
                    .read<CaseAcceptanceRequestCubit>()
                    .loadConfiguration(force: true),
              ),
            ),
          );
        }
        return _LoadedContent(args: args, onOpenPicker: _openPicker);
      },
    );
  }
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.args, required this.onOpenPicker});

  final CaseAcceptanceRequestArgs args;
  final void Function(
    BuildContext context, {
    int? toothNumber,
    ProcedureRequestEntity? existing,
  }) onOpenPicker;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CaseAcceptanceRequestCubit>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        PatientSummaryCard(args: args),
        const SizedBox(height: AppDimensions.lg),
        BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
          buildWhen: (p, c) =>
              p.requiresDentalChart != c.requiresDentalChart ||
              p.selectedTeeth != c.selectedTeeth,
          builder: (context, state) {
            if (state.requiresDentalChart) {
              return DentalChartCard(
                selectedTeeth: state.selectedTeeth,
                onToothTap: (fdi) => onOpenPicker(
                  context,
                  toothNumber: fdi,
                  existing: state.requestForTooth(fdi),
                ),
              );
            }
            return AddProcedureCard(
              onTap: () => onOpenPicker(context),
            );
          },
        ),
        const SizedBox(height: AppDimensions.xl),
        BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
          buildWhen: (p, c) =>
              p.requests != c.requests ||
              p.requiresDentalChart != c.requiresDentalChart,
          builder: (context, state) => SelectedProceduresSection(
            requests: state.orderedRequests,
            emptyMessage: state.requiresDentalChart
                ? 'Please select at least one tooth and procedure.'
                : 'Please add at least one procedure.',
            onEdit: (request) => onOpenPicker(
              context,
              toothNumber: request.toothNumber,
              existing: request,
            ),
            onRemove: cubit.removeRequest,
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
          buildWhen: (p, c) =>
              p.canSubmit != c.canSubmit || p.submission != c.submission,
          builder: (context, state) => AppPrimaryButton(
            label: state.isSubmitting ? 'Submitting…' : 'Submit Request',
            isLoading: state.isSubmitting,
            onPressed: state.canSubmit ? cubit.submit : null,
            trailingIcon: Icons.send_rounded,
          ),
        ),
      ],
    );
  }
}