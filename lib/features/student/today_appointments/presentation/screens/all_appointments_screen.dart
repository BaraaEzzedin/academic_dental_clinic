import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/entities/today_appointment_entity.dart';
import '../../domain/use_cases/get_today_appointments_use_case.dart';
import '../manager/today_appointments/today_appointments_cubit.dart';
import '../manager/today_appointments/today_appointments_state.dart';
import '../widgets/schedule_group.dart';
import '../widgets/today_schedule_shimmer.dart';

/// Full schedule: every today and upcoming appointment, unlimited. Reached from
/// the Home schedule section's "View All" action.
class AllAppointmentsScreen extends StatelessWidget {
  const AllAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayAppointmentsCubit>(
      create: (_) => TodayAppointmentsCubit(sl<GetTodayAppointmentsUseCase>())
        ..loadAppointments(),
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
                child: CaseDetailsTopBar(title: 'Appointments'),
              ),
              Expanded(
                child: BlocBuilder<TodayAppointmentsCubit,
                    TodayAppointmentsState>(
                  builder: (context, state) => _Content(state: state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final TodayAppointmentsState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
        ),
        child: TodayScheduleShimmer(itemCount: 4),
      );
    }
    if (state.hasError) {
      return _CenteredMessage(
        icon: Icons.error_outline_rounded,
        message: state.errorMessage ?? 'Failed to load appointments.',
        onRetry: context.read<TodayAppointmentsCubit>().loadAppointments,
      );
    }
    if (state.isEmpty) {
      return const _CenteredMessage(
        icon: Icons.event_available_outlined,
        message: 'No scheduled appointments.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        if (state.today.isNotEmpty)
          ScheduleGroup(
            label: 'Today',
            items: state.today,
            onItemTap: (item) => _openCase(context, item),
          ),
        if (state.today.isNotEmpty && state.upcoming.isNotEmpty)
          const SizedBox(height: AppDimensions.xl),
        if (state.upcoming.isNotEmpty)
          ScheduleGroup(
            label: 'Upcoming',
            items: state.upcoming,
            showDate: true,
            onItemTap: (item) => _openCase(context, item),
          ),
      ],
    );
  }

  /// Opens the case behind a tapped appointment.
  void _openCase(BuildContext context, AppointmentEntity item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CaseDetailsScreen(caseId: item.clinicalCaseId),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textHint),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.lg),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}