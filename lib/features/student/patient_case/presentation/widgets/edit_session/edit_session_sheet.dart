import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/service_locator/auth_service.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/widgets/error_retry_view.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../domain/use_cases/complete_treatment_session_use_case.dart';
import '../../../domain/use_cases/get_materials_use_case.dart';
import '../../../domain/use_cases/get_planned_procedures_use_case.dart';
import '../../manager/edit_session/edit_session_cubit.dart';
import '../../manager/edit_session/edit_session_state.dart';
import '../../models/session.dart';
import 'clinical_notes_field.dart';
import 'completed_item_card.dart';
import 'edit_session_footer.dart';
import 'edit_session_header.dart';
import 'edit_session_shimmer.dart';
import 'materials_selector.dart';
import 'treatment_item_card.dart';

/// Opens the "Edit Session" sheet for [session]. Loads the session's planned
/// procedures and the subject's materials, then lets the student update
/// statuses, pick materials and add a note before completing the session.
/// Resolves with `true` when the session was completed.
Future<bool?> showEditSessionSheet(
  BuildContext context, {
  required Session session,
  required int subjectId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => EditSessionCubit(
        getPlannedProcedures: sl<GetPlannedProceduresUseCase>(),
        getMaterials: sl<GetMaterialsUseCase>(),
        completeSession: sl<CompleteTreatmentSessionUseCase>(),
        treatmentSessionId: session.id,
        subjectId: subjectId,
      )..load(),
      child: EditSessionSheet(session: session),
    ),
  );
}

class EditSessionSheet extends StatefulWidget {
  const EditSessionSheet({super.key, required this.session});

  final Session session;

  @override
  State<EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<EditSessionSheet> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<EditSessionCubit>();
    final succeeded = await cubit.submit(_noteController.text);
    if (!context.mounted) return;
    if (!succeeded) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
              cubit.state.submitError ?? 'Could not complete the session.',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        );
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
        child: BlocBuilder<EditSessionCubit, EditSessionState>(
          builder: (context, state) {
            final cubit = context.read<EditSessionCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetGrabber(),
                EditSessionHeader(
                  title: widget.session.title,
                  date: widget.session.date,
                  onClose: state.isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const Divider(height: 1, color: AppColors.dividerLine),
                Flexible(
                  child: _buildBody(context, state, cubit),
                ),
                if (state.status == EditSessionStatus.loaded)
                  EditSessionFooter(
                    onCancel: () => Navigator.of(context).pop(),
                    onUpdate: () => _submit(context),
                    isSubmitting: state.isSubmitting,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    EditSessionState state,
    EditSessionCubit cubit,
  ) {
    if (state.isLoading) {
      return const EditSessionShimmer();
    }
    if (state.hasError || state.data == null) {
      return SizedBox(
        height: 240,
        child: ErrorRetryView(
          message: state.errorMessage ?? 'Could not load the session.',
          onRetry: cubit.load,
        ),
      );
    }

    final editable = state.editableProcedures;
    final completed = state.completedProcedures;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (editable.isNotEmpty) ...[
            const _SectionHeader(
              icon: Icons.checklist_rounded,
              title: 'Treatment Items',
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Update the status of each item.',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: AppDimensions.lg),
            for (var i = 0; i < editable.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == editable.length - 1 ? 0 : AppDimensions.lg,
                ),
                child: TreatmentItemCard(
                  procedure: editable[i],
                  selected: state.statusFor(editable[i]),
                  onStatusChanged: (status) =>
                      cubit.setStatus(editable[i].id, status),
                ),
              ),
            const SizedBox(height: AppDimensions.xl),
          ],
          if (completed.isNotEmpty) ...[
            const _SectionHeader(
              icon: Icons.verified_rounded,
              title: 'Completed Treatment Items',
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Finished treatment work — read-only and preserved for '
              'historical reference.',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: AppDimensions.lg),
            for (var i = 0; i < completed.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == completed.length - 1 ? 0 : AppDimensions.lg,
                ),
                child: CompletedItemCard(procedure: completed[i]),
              ),
            const SizedBox(height: AppDimensions.xl),
          ],
          const _SectionHeader(
            icon: Icons.science_rounded,
            title: 'Materials',
          ),
          const SizedBox(height: AppDimensions.md),
          MaterialsSelector(
            materials: state.materials,
            selectedIds: state.selectedMaterialIds,
            isLoading: state.isLoadingMaterials,
            hasError: state.hasMaterialsError,
            onToggle: cubit.toggleMaterial,
            onRetry: cubit.retryMaterials,
          ),
          const SizedBox(height: AppDimensions.xl),
          const _SectionHeader(
            icon: Icons.notes_rounded,
            title: 'Clinical Notes',
          ),
          const SizedBox(height: AppDimensions.md),
          ClinicalNotesField(controller: _noteController),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
