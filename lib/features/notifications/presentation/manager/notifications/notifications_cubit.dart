import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_notifications_use_case.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._getNotifications)
      : super(const NotificationsState());

  final GetNotificationsUseCase _getNotifications;

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await _getNotifications();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: notifications,
        ),
      ),
    );
  }
}