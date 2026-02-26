abstract class BaseEntity {
  final String objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
    };
  }
}
