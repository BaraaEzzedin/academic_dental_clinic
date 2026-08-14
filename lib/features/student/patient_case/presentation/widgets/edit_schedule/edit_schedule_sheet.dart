import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/service_locator/auth_service.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../domain/use_cases/edit_treatment_session_use_case.dart';
import '../../manager/edit_schedule/edit_schedule_cubit.dart';
import '../../manager/edit_schedule/edit_schedule_state.dart';
import '../../models/session.dart';
import '../add_session/available_times_section.dart';
import '../add_session/session_calendar.dart';
import '../add_session/session_title_field.dart';

/// Opens the "Edit Session" (reschedule) sheet for an upcoming [session].
/// Returns `true` when the session was updated.
Future<bool?> showEditScheduleSheet(
  BuildContext context, {
  required Session session,
  required int subjectId,
}) {
  final initialTime = _normalizeTime(session.startTimeRaw);
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => EditScheduleCubit(
        getAvailableAppointments: sl<GetAvailableAppointmentsUseCase>(),
        editSession: sl<EditTreatmentSessionUseCase>(),
        treatmentSessionId: session.id,
        subjectId: subjectId,
        initialTitle: session.title,
        initialDate: session.appointmentDate,
        initialTime: initialTime,
      )..init(),
      child: EditScheduleSheet(session: session),
    ),
  );
}

/// Normalizes a `HH:mm[:ss]` string to `HH:mm`.
String _normalizeTime(String raw) =>
    raw.length >= 5 ? raw.substring(0, 5) : raw;

class EditScheduleSheet extends StatefulWidget {
  const EditScheduleSheet({super.key, required this.session});

  final Session session;

  @override
  State<EditScheduleSheet> createState() => _EditScheduleSheetState();
}

class _EditScheduleSheetState extends State<EditScheduleSheet> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.session.title);

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<EditScheduleCubit>();
    final succeeded = await cubit.submit();
    if (!context.mounted) return;
    if (!succeeded) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
              cubit.state.submitError ?? 'Could not update the session.',
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
        child: BlocBuilder<EditScheduleCubit, EditScheduleState>(
          builder: (context, state) {
            final cubit = context.read<EditScheduleCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetGrabber(),
                _Header(
                  onClose: state.isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const Divider(height: 1, color: AppColors.dividerLine),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SessionTitleField(
                          controller: _titleController,
                          enabled: !state.isSubmitting,
                          onChanged: cubit.setTitle,
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        SessionCalendar(
                          focusedMonth: state.focusedMonth,
                          selectedDate: state.selectedDate,
                          enabled: !state.isSubmitting,
                          onSelectDate: cubit.selectDate,
                          onPreviousMonth: cubit.previousMonth,
                          onNextMonth: cubit.nextMonth,
                        ),
                        const SizedBox(height: AppDimensions.xl),
                        AvailableTimesSection(
                          selectedDate: state.selectedDate,
                          status: state.timesStatus,
                          times: state.availableTimes,
                          selectedTime: state.selectedTime,
                          onSelectTime: cubit.selectTime,
                        ),
                      ],
                    ),
                  ),
                ),
                _Footer(
                  canSubmit: state.canSubmit,
                  isSubmitting: state.isSubmitting,
                  onSubmit: () => _submit(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.md,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.caseChipBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(Icons.edit_calendar_rounded,
                color: AppColors.primary),
          ),
          const SizedBox(width: AppDimensions.md),
          const Expanded(
            child: Text(
              'Edit Session',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            visualDensity: VisualDensity.compact,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.canSubmit,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.dividerLine)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.lg,
        AppDimensions.xl,
        AppDimensions.lg + MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canSubmit ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            disabledForegroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            textStyle: AppTextStyles.button,
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : const Text('Save Changes'),
        ),
      ),
    );
  }
}
