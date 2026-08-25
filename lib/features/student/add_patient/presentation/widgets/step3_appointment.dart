import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/add_session/available_times_section.dart';
import '../../../patient_case/presentation/widgets/add_session/session_calendar.dart';
import '../manager/add_patient/add_patient_cubit.dart';
import '../manager/add_patient/add_patient_state.dart';

/// Step 3 — pick the initial appointment date and time. Available times are
/// loaded for the selected subject + date (same UI as the open-case flow).
class Step3Appointment extends StatelessWidget {
  const Step3Appointment({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPatientCubit>();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        AppDimensions.lg,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        Text('Appointment', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.lg),
        BlocBuilder<AddPatientCubit, AddPatientState>(
          buildWhen: (p, c) =>
              p.focusedMonth != c.focusedMonth ||
              p.selectedDate != c.selectedDate ||
              p.timesStatus != c.timesStatus ||
              p.availableTimes != c.availableTimes ||
              p.selectedTime != c.selectedTime,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SessionCalendar(
                  focusedMonth: state.focusedMonth,
                  selectedDate: state.selectedDate,
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
            );
          },
        ),
      ],
    );
  }
}
