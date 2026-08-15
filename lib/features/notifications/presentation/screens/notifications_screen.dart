import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/service_locator/auth_service.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../manager/notifications/notifications_cubit.dart';
import '../manager/notifications/notifications_state.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notifications_list_shimmer.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) =>
          NotificationsCubit(sl<GetNotificationsUseCase>())..loadNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.topBarBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
          title: const Text('Notifications', style: AppTextStyles.topBarTitle),
        ),
        body: SafeArea(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state.isLoading || state.status == NotificationsStatus.initial) {
                return const NotificationsListShimmer();
              }
              if (state.hasError) {
                return ErrorRetryView(
                  message: state.errorMessage ?? 'Failed to load notifications.',
                  onRetry:
                      context.read<NotificationsCubit>().loadNotifications,
                );
              }
              if (state.isEmpty) {
                return const _EmptyNotifications();
              }
              return RefreshIndicator(
                onRefresh:
                    context.read<NotificationsCubit>().loadNotifications,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontalPadding,
                    vertical: AppDimensions.lg,
                  ),
                  itemCount: state.notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDimensions.md),
                  itemBuilder: (context, index) => NotificationTile(
                    notification: state.notifications[index],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_off_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No notifications yet',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              "You're all caught up. New notifications will appear here.",
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}