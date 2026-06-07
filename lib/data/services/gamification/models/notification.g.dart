// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: (json['id'] as num).toInt(),
      templateKey: json['template_key'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      readAt: json['read_at'] as String?,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'template_key': instance.templateKey,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'read_at': instance.readAt,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };

NotificationsResponse _$NotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationsResponseToJson(
        NotificationsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'unread_count': instance.unreadCount,
    };

NotificationPreference _$NotificationPreferenceFromJson(
        Map<String, dynamic> json) =>
    NotificationPreference(
      channel: json['channel'] as String,
      type: json['type'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$NotificationPreferenceToJson(
        NotificationPreference instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'type': instance.type,
      'enabled': instance.enabled,
    };

NotificationPreferencesResponse _$NotificationPreferencesResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferencesResponse(
      data: (json['data'] as List<dynamic>)
          .map(
              (e) => NotificationPreference.fromJson(e as Map<String, dynamic>))
          .toList(),
      channels:
          (json['channels'] as List<dynamic>).map((e) => e as String).toList(),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NotificationPreferencesResponseToJson(
        NotificationPreferencesResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'channels': instance.channels,
      'types': instance.types,
    };
