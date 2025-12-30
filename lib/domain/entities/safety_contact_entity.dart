class SafetyContactEntity {
  final String objectId;
  final String name;
  final String phoneNumber;
  final String avatarUrl;
  final String createdAt;
  final String updatedAt;

  SafetyContactEntity({
    required this.objectId,
    required this.name,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  SafetyContactEntity copyWith({
    String? name,
    String? phoneNumber,
  }) {
    return SafetyContactEntity(
      objectId: objectId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
