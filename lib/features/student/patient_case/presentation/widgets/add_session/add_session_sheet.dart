import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/service_locator/auth_service.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../domain/use_cases/create_treatment_session_use_case.dart';
import '../../manager/add_session/add_session_cubit.dart';
import '../../manager/add_session/add_session_state.dart';
import 'available_times_section.dart';
import 'session_calendar.dart';
import 'session_title_field.dart';

class AddSessionResult {
  const AddSessionResult({
    required this.title,
    this.date,
    this.time,
  });

  final String title;

  /// Null for the first session (no appointment scheduled yet).
  final DateTime? date;
  final String? time;
}


/// Shows the "Add New Session" sheet for the case [clinicalCaseId].
///
/// When [isFirstSession] is true the sheet collects only a title (the first
/// session has no appointment yet); otherwise the calendar and available times
/// (loaded per [subjectId]) are shown. Returns the created session's details on
/// success, or `null` if dismissed.
Future<AddSessionResult?> showAddSessionSheet(
  BuildContext context, {
  required int clinicalCaseId,
  required int subjectId,
  required bool isFirstSession,
}) {
  return showModalBottomSheet<AddSessionResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => AddSessionCubit(
        getAvailableAppointments: sl<GetAvailableAppointmentsUseCase>(),
        createTreatmentSession: sl<CreateTreatmentSessionUseCase>(),
        clinicalCaseId: clinicalCaseId,
        subjectId: subjectId,
        isFirstSession: isFirstSession,
      ),
      child: const AddSessionSheet(),
    ),
  );
}

class AddSessionSheet extends StatefulWidget {
  const AddSessionSheet({super.key});

  @override
  State<AddSessionSheet> createState() => _AddSessionSheetState();
}

class _AddSessionSheetState extends State<AddSessionSheet> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<AddSessionCubit>();
    final succeeded = await cubit.submit();
    if (!context.mounted) return;
    final state = cubit.state;
    if (!succeeded) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
              state.submitError ?? 'Could not add the session.',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        );
      return;
    }
    Navigator.of(context).pop(
      AddSessionResult(
        title: state.title.trim(),
        date: state.selectedDate,
        time: state.selectedTime,
      ),
    );
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
        child: BlocBuilder<AddSessionCubit, AddSessionState>(
          builder: (context, state) {
            final cubit = context.read<AddSessionCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetGrabber(),
                _Header(
                  isFirstSession: state.isFirstSession,
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
                        if (!state.isFirstSession) ...[
                          const _NextAppointmentBanner(),
                          const SizedBox(height: AppDimensions.lg),
                        ],
                        SessionTitleField(
                          controller: _titleController,
                          enabled: !state.isSubmitting,
                          onChanged: cubit.setTitle,
                        ),
                        // The first session has no appointment: title only.
                        if (!state.isFirstSession) ...[
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
                      ],
                    ),
                  ),
                ),
                _Footer(
                  isFirstSession: state.isFirstSession,
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
  const _Header({required this.isFirstSession, required this.onClose});

  final bool isFirstSession;
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
            child: const Icon(Icons.add_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              isFirstSession ? 'Add First Session' : 'Add Session',
              style: const TextStyle(
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

class _NextAppointmentBanner extends StatelessWidget {
  const _NextAppointmentBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: const [
          Icon(Icons.event_available_rounded,
              size: 22, color: AppColors.primary),
          SizedBox(width: AppDimensions.md),
          Text(
            'Next appointment date',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isFirstSession,
    required this.canSubmit,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isFirstSession;
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
              : Text(
                  isFirstSession ? 'Create First Session' : 'Create Session',
                ),
        ),
      ),
    );
  }
}