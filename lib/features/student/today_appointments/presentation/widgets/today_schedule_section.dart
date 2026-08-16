import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/use_cases/get_today_appointments_use_case.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../../domain/entities/today_appointment_entity.dart';
import '../manager/today_appointments/today_appointments_cubit.dart';
import '../manager/today_appointments/today_appointments_state.dart';
import '../screens/all_appointments_screen.dart';
import 'schedule_group.dart';
import 'today_schedule_shimmer.dart';

/// Home screen's "Your Schedule" section.
///
/// Prioritises today's appointments: when any exist they are all shown as a
/// timeline. Otherwise it previews up to two upcoming appointments. A friendly
/// empty state appears only when there is nothing in either group.
class TodayScheduleSection extends StatelessWidget {
  const TodayScheduleSection({super.key});

  /// How many upcoming appointments to preview on Home when today is empty.
  static const int _upcomingPreviewLimit = 2;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayAppointmentsCubit>(
      create: (_) =>
          TodayAppointmentsCubit(sl<GetTodayAppointmentsUseCase>())
            ..loadAppointments(),
      child: BlocBuilder<TodayAppointmentsCubit, TodayAppointmentsState>(
        builder: (context, state) {
          // "View All" is only meaningful once there is something to browse.
          final showViewAll = !state.isLoading &&
              !state.hasError &&
              !state.isEmpty;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Your Schedule',
                        style: AppTextStyles.sectionTitle),
                  ),
                  if (showViewAll) const _ViewAllButton(),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _SectionContent(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.state});

  final TodayAppointmentsState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const TodayScheduleShimmer();
    }
    if (state.hasError) {
      return _CompactError(
        message: state.errorMessage ?? 'Failed to load your schedule.',
        onRetry: context.read<TodayAppointmentsCubit>().loadAppointments,
      );
    }
    if (state.isEmpty) {
      return const _CompactEmpty();
    }

    // Today takes priority; fall back to a short preview of upcoming.
    if (state.today.isNotEmpty) {
      return ScheduleGroup(
        label: 'Today',
        items: state.today,
        onItemTap: (item) => _openCase(context, item),
      );
    }
    return ScheduleGroup(
      label: 'Upcoming',
      items: state.upcoming
          .take(TodayScheduleSection._upcomingPreviewLimit)
          .toList(),
      showDate: true,
      onItemTap: (item) => _openCase(context, item),
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

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AllAppointmentsScreen(),
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm,
          vertical: AppDimensions.xs,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: AppTextStyles.viewDetailsButton,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('View All'),
          SizedBox(width: 2),
          Icon(Icons.chevron_right_rounded, size: 18),
        ],
      ),
    );
  }
}

class _CompactEmpty extends StatelessWidget {
  const _CompactEmpty();

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.event_available_outlined,
      iconColor: AppColors.textHint,
      child: Text(
        'No scheduled appointments.',
        style: AppTextStyles.subtitle,
      ),
    );
  }
}

class _CompactError extends StatelessWidget {
  const _CompactError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      child: Row(
        children: [
          Expanded(child: Text(message, style: AppTextStyles.subtitle)),
          const SizedBox(width: AppDimensions.sm),
          TextButton.icon(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.viewDetailsButton,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}