import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../entities/app_notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase
    implements UseCaseNoParam<List<AppNotificationEntity>> {
  const GetNotificationsUseCase(this.repository);

  final NotificationsRepository repository;

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> call() {
    return repository.getNotifications();
  }
}