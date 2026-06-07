import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification {
  final int id;
  @JsonKey(name: 'template_key')
  final String? templateKey;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  @JsonKey(name: 'read_at')
  final String? readAt;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  AppNotification({
    required this.id,
    this.templateKey,
    this.title,
    this.body,
    this.data,
    this.readAt,
    required this.isRead,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);
}

@JsonSerializable()
class NotificationsResponse {
  final List<AppNotification> data;
  @JsonKey(name: 'unread_count')
  final int? unreadCount;

  NotificationsResponse({required this.data, this.unreadCount});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}

@JsonSerializable()
class NotificationPreference {
  final String channel;
  final String type;
  final bool enabled;

  NotificationPreference({
    required this.channel,
    required this.type,
    required this.enabled,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferenceToJson(this);
}

@JsonSerializable()
class NotificationPreferencesResponse {
  final List<NotificationPreference> data;
  final List<String> channels;
  final List<String> types;

  NotificationPreferencesResponse({
    required this.data,
    required this.channels,
    required this.types,
  });

  factory NotificationPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesResponseToJson(this);
}
