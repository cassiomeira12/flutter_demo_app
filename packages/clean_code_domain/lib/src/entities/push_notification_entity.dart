import 'package:clean_code_domain/clean_code_domain.dart';

class PushNotificationEntity extends ParserToJson {
  final String? id;
  final String title;
  final String body;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final String? androidChannelId;
  final String? androidPriority;
  final String? androidVisibility;
  final String? androidTag;
  final bool? androidSticky;

  PushNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.data,
    required this.androidChannelId,
    required this.androidPriority,
    required this.androidVisibility,
    required this.androidTag,
    required this.androidSticky,
  });

  PushNotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? androidChannelId,
    String? androidPriority,
    String? androidVisibility,
    String? androidTag,
    bool? androidSticky,
  }) {
    return PushNotificationEntity(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      androidChannelId: androidChannelId ?? this.androidChannelId,
      androidPriority: androidPriority ?? this.androidPriority,
      androidVisibility: androidVisibility ?? this.androidVisibility,
      androidTag: androidTag ?? this.androidTag,
      androidSticky: androidSticky ?? this.androidSticky,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notification': {'title': title, 'body': body},
      'imageUrl': imageUrl,
      'data': data,
      'androidChannelId': androidChannelId,
      'androidPriority': androidPriority,
      'androidVisibility': androidVisibility,
      'androidTag': androidTag,
      'androidSticky': androidSticky,
    };
  }
}
