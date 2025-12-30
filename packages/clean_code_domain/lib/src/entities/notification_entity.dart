class NotificationEntity {
  final String objectId;
  final String title;
  final String body;
  final bool viewed;
  final String? imageUrl;

  NotificationEntity({
    required this.objectId,
    required this.title,
    required this.body,
    required this.viewed,
    required this.imageUrl,
  });

  NotificationEntity copyWith({
    String? title,
    String? body,
    bool? viewed,
    String? imageUrl,
  }) {
    return NotificationEntity(
      objectId: objectId,
      title: title ?? this.title,
      body: body ?? this.body,
      viewed: viewed ?? this.viewed,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'title': title,
      'body': body,
      'viewed': viewed,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
