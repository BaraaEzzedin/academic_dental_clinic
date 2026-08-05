import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/use_cases/get_today_appointments_use_case.dart';
import '../manager/today_appointments/today_appointments_cubit.dart';
import '../manager/today_appointments/today_appointments_state.dart';
import 'schedule_item_card.dart';
import 'today_schedule_shimmer.dart';

class TodayScheduleSection extends StatelessWidget {
  const TodayScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayAppointmentsCubit>(
      create: (_) =>
          TodayAppointmentsCubit(sl<GetTodayAppointmentsUseCase>())
            ..loadAppointments(),
      child: BlocBuilder<TodayAppointmentsCubit, TodayAppointmentsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Schedule", style: AppTextStyles.sectionTitle),
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
        message: state.errorMessage ?? "Failed to load today's schedule.",
        onRetry: context.read<TodayAppointmentsCubit>().loadAppointments,
      );
    }
    if (state.isEmpty) {
      return const _CompactEmpty();
    }

    final appointments = state.appointments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < appointments.length; i++)
          ScheduleItemCard(
            item: appointments[i],
            isFirst: i == 0,
            isLast: i == appointments.length - 1,
            // TODO(feature): open the appointment details screen.
            onTap: () {},
          ),
      ],
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
        'No appointments scheduled for today.',
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