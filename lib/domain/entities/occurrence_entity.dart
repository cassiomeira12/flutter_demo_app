class OccurrenceEntity {
  final String objectId;
  final double latitude;
  final double longitude;
  final int accuracy;
  final String createdAt;

  OccurrenceEntity({
    required this.objectId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.createdAt,
  });

  OccurrenceEntity copyWith({
    String? name,
    double? latitude,
    double? longitude,
    int? accuracy,
    String? createdAt,
  }) {
    return OccurrenceEntity(
      objectId: objectId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
