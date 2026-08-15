import 'package:equatable/equatable.dart';

import '../../../domain/entities/app_notification_entity.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
  });

  final NotificationsStatus status;
  final List<AppNotificationEntity> notifications;
  final String? errorMessage;

  bool get isLoading => status == NotificationsStatus.loading;
  bool get hasError => status == NotificationsStatus.error;
  bool get isEmpty =>
      status == NotificationsStatus.loaded && notifications.isEmpty;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotificationEntity>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage];
}