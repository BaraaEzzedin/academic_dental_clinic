import '../../domain/entities/app_notification_entity.dart';

class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      body: (json['body'] ?? json['message']) as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}