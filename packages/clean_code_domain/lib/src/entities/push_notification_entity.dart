class PushNotificationEntity {
  final String? id;
  final String title;
  final String body;
  final String? image;
  final Map<String, dynamic>? data;

  PushNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.data,
  });

  PushNotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? image,
    Map<String, dynamic>? data,
  }) {
    return PushNotificationEntity(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notification': {'title': title, 'body': body},
      'image': image,
      'data': data,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
