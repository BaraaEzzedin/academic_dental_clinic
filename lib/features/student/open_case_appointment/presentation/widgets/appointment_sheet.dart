import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/sheet_grabber.dart';
import '../../../patient_case/presentation/widgets/add_session/available_times_section.dart';
import '../../../patient_case/presentation/widgets/add_session/session_calendar.dart';
import '../manager/appointment/appointment_cubit.dart';
import '../manager/appointment/appointment_state.dart';
import 'appointment_title_field.dart';

/// The booked appointment, returned when the sheet is submitted.
class AppointmentResult {
  const AppointmentResult({
    required this.title,
    required this.date,
    required this.time,
  });

  final String title;
  final DateTime date;
  final String time;
}

/// Opens the "Book Appointment" bottom sheet (calendar + available times),
/// pre-filled with the "Initial Examination" title. Resolves to the booked
/// [AppointmentResult], or `null` if dismissed.
Future<AppointmentResult?> showAppointmentSheet(BuildContext context) {
  return showModalBottomSheet<AppointmentResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => AppointmentCubit(),
      child: const AppointmentSheet(),
    ),
  );
}

class AppointmentSheet extends StatefulWidget {
  const AppointmentSheet({super.key});

  @override
  State<AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends State<AppointmentSheet> {
  final TextEditingController _titleController =
      TextEditingController(text: kInitialExaminationTitle);

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<AppointmentCubit>();
    await cubit.submit();
    if (!context.mounted) return;
    final state = cubit.state;
    if (state.selectedDate == null || state.selectedTime == null) return;
    Navigator.of(context).pop(
      AppointmentResult(
        title: state.title.trim(),
        date: state.selectedDate!,
        time: state.selectedTime!,
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
        child: BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, state) {
            final cubit = context.read<AppointmentCubit>();
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
                        const _NextAppointmentBanner(),
                        const SizedBox(height: AppDimensions.lg),
                        AppointmentTitleField(
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
            child: const Icon(
              Icons.event_note_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          const Expanded(
            child: Text(
              'Book Appointment',
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
            'Pick a date for the initial examination',
            style: TextStyle(
              fontSize: 15,
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
              : const Text('Submit Appointment'),
        ),
      ),
    );
  }
}