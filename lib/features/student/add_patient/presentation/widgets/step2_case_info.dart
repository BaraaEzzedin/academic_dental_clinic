import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../../../core/widgets/sheet_grabber.dart';
import '../../../case_acceptance_request/domain/entities/procedure_request_entity.dart';
import '../../../case_acceptance_request/presentation/widgets/add_procedure_card.dart';
import '../../../case_acceptance_request/presentation/widgets/dental_chart_card.dart';
import '../../../case_acceptance_request/presentation/widgets/procedure_picker_sheet.dart';
import '../../../case_acceptance_request/presentation/widgets/selected_procedures_section.dart';
import '../../../clinical_courses/domain/entities/clinical_course_entity.dart';
import '../manager/add_patient/add_patient_cubit.dart';
import '../manager/add_patient/add_patient_state.dart';
import 'case_images_section.dart';
import 'case_info_shimmer.dart';

/// Step 2 — choose a subject, then plan procedures (dental chart or procedure
/// list, driven by the subject configuration) and attach case images.
class Step2CaseInfo extends StatelessWidget {
  const Step2CaseInfo({super.key});

  void _openPicker(
    BuildContext context, {
    int? toothNumber,
    ProcedureRequestEntity? existing,
  }) {
    final cubit = context.read<AddPatientCubit>();
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
    final cubit = context.read<AddPatientCubit>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        AppDimensions.lg,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        Text('Case Information', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.lg),
        BlocBuilder<AddPatientCubit, AddPatientState>(
          buildWhen: (p, c) =>
              p.subjectsStatus != c.subjectsStatus ||
              p.selectedSubjectId != c.selectedSubjectId,
          builder: (context, state) => _SubjectSelector(
            subjects: state.subjects,
            isLoading: state.isLoadingSubjects,
            hasError: state.hasSubjectsError,
            selectedId: state.selectedSubjectId,
            onRetry: () => cubit.loadSubjects(force: true),
            onSelect: cubit.selectSubject,
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        BlocBuilder<AddPatientCubit, AddPatientState>(
          buildWhen: (p, c) =>
              p.selectedSubjectId != c.selectedSubjectId ||
              p.configStatus != c.configStatus ||
              p.requiresDentalChart != c.requiresDentalChart ||
              p.selectedTeeth != c.selectedTeeth ||
              p.requests != c.requests,
          builder: (context, state) {
            if (state.selectedSubjectId == null) {
              return _Hint(
                icon: Icons.touch_app_outlined,
                message: 'Select a subject to plan its procedures.',
              );
            }
            if (state.isLoadingConfig) {
              return const CaseInfoShimmer();
            }
            if (state.hasConfigError) {
              return ErrorRetryView(
                message: state.configError ?? 'Could not load the subject.',
                onRetry: cubit.reloadConfiguration,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.requiresDentalChart)
                  DentalChartCard(
                    selectedTeeth: state.selectedTeeth,
                    onToothTap: (fdi) => _openPicker(
                      context,
                      toothNumber: fdi,
                      existing: state.requestForTooth(fdi),
                    ),
                  )
                else
                  AddProcedureCard(onTap: () => _openPicker(context)),
                const SizedBox(height: AppDimensions.xl),
                SelectedProceduresSection(
                  requests: state.orderedRequests,
                  emptyMessage: state.requiresDentalChart
                      ? 'Please select at least one tooth and procedure.'
                      : 'Please add at least one procedure.',
                  onEdit: (request) => _openPicker(
                    context,
                    toothNumber: request.toothNumber,
                    existing: request,
                  ),
                  onRemove: cubit.removeRequest,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppDimensions.xl),
        const CaseImagesSection(),
      ],
    );
  }
}

class _SubjectSelector extends StatelessWidget {
  const _SubjectSelector({
    required this.subjects,
    required this.isLoading,
    required this.hasError,
    required this.selectedId,
    required this.onRetry,
    required this.onSelect,
  });

  final List<ClinicalCourseEntity> subjects;
  final bool isLoading;
  final bool hasError;
  final int? selectedId;
  final VoidCallback onRetry;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    ClinicalCourseEntity? selected;
    for (final s in subjects) {
      if (s.id == selectedId) selected = s;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject', style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppDimensions.sm),
        if (isLoading)
          Container(
            height: 56,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Text('Loading subjects…', style: AppTextStyles.hint),
          )
        else if (hasError)
          ErrorRetryView(
            message: 'Could not load your subjects.',
            onRetry: onRetry,
          )
        else
          InkWell(
            onTap: subjects.isEmpty
                ? null
                : () => _openSubjectSheet(context, selected),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school_outlined,
                      color: AppColors.textSecondary,
                      size: AppDimensions.iconSize),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(
                      selected?.name ?? 'Select a subject',
                      style:
                          selected != null ? AppTextStyles.input : AppTextStyles.hint,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openSubjectSheet(
    BuildContext context,
    ClinicalCourseEntity? selected,
  ) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (_) => _SubjectSheet(subjects: subjects, selectedId: selected?.id),
    );
    if (picked != null) onSelect(picked);
  }
}

class _SubjectSheet extends StatelessWidget {
  const _SubjectSheet({required this.subjects, required this.selectedId});

  final List<ClinicalCourseEntity> subjects;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Row(
              children: [
                Text('Select Subject', style: AppTextStyles.sectionTitle),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.dividerLine),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
              itemCount: subjects.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.dividerLine),
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final selected = subject.id == selectedId;
                return ListTile(
                  title: Text(subject.name, style: AppTextStyles.caseProcedure),
                  subtitle: subject.shortName.trim().isEmpty
                      ? null
                      : Text(subject.shortName, style: AppTextStyles.helperText),
                  trailing: selected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(subject.id),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: Text(message, style: AppTextStyles.subtitle)),
        ],
      ),
    );
  }
}
