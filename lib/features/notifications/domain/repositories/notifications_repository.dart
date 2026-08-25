import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<AppNotificationEntity>>> getNotifications();
}