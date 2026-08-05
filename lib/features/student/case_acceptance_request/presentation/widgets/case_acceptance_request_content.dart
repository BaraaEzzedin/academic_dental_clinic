import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../manager/case_acceptance_request/case_acceptance_request_cubit.dart';
import '../manager/case_acceptance_request/case_acceptance_request_state.dart';
import '../models/case_acceptance_request_args.dart';
import 'dental_chart_card.dart';
import 'diagnosis_field.dart';
import 'patient_summary_card.dart';
import 'procedure_picker_sheet.dart';
import 'selected_procedures_section.dart';

class CaseAcceptanceRequestContent extends StatelessWidget {
  const CaseAcceptanceRequestContent({super.key, required this.args});

  final CaseAcceptanceRequestArgs args;

  void _openPicker(BuildContext context, int toothNumber) {
    showProcedurePickerSheet(
      context,
      cubit: context.read<CaseAcceptanceRequestCubit>(),
      toothNumber: toothNumber,
    );
  }

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
          buildWhen: (p, c) => p.selections != c.selections,
          builder: (context, state) => DentalChartCard(
            selectedTeeth: state.selections.keys.toSet(),
            onToothTap: (fdi) => _openPicker(context, fdi),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
          buildWhen: (p, c) => p.selections != c.selections,
          builder: (context, state) => SelectedProceduresSection(
            selections: state.orderedSelections,
            onEdit: (fdi) => _openPicker(context, fdi),
            onRemove: cubit.removeSelection,
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        DiagnosisField(onChanged: cubit.diagnosisChanged),
        const SizedBox(height: AppDimensions.xl),
        BlocBuilder<CaseAcceptanceRequestCubit, CaseAcceptanceRequestState>(
          buildWhen: (p, c) =>
              p.canSubmit != c.canSubmit || p.submission != c.submission,
          builder: (context, state) => AppPrimaryButton(
            label: state.isSubmitting
                ? 'Submitting…'
                : 'Submit Acceptance Request',
            onPressed: state.canSubmit ? cubit.submit : null,
            trailingIcon: state.isSubmitting ? null : Icons.send_rounded,
          ),
        ),
      ],
    );
  }
}