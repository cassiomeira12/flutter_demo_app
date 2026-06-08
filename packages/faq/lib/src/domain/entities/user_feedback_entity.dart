import 'package:clean_code_domain/clean_code_domain.dart';

class UserFeedbackEntity extends BaseEntity {
  final String name;
  final String email;
  final String feedback;

  UserFeedbackEntity({
    super.objectId = '',
    super.createdAt,
    super.updatedAt,
    required this.name,
    required this.email,
    required this.feedback,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
      'name': name,
      'email': email,
      'feedback': feedback,
    };
  }

  @override
  UserFeedbackEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? email,
    String? feedback,
  }) {
    return UserFeedbackEntity(
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      feedback: feedback ?? this.feedback,
    );
  }
}
