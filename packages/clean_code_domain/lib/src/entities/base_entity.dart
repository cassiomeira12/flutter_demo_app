abstract class BaseEntity {
  final String objectId;
  final String createdAt;
  final String updatedAt;

  BaseEntity({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseEntity copyWith({
    String? objectId,
    String? createdAt,
    String? updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
