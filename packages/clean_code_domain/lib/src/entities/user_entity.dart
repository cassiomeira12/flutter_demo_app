import 'package:core/core.dart';

class UserEntity {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatarUrl;
  final String? createdAt;
  final String? updatedAt;
  final List<UserPermissionsEnum> permissions;
  final String? locale;
  final String? sessionToken;
  final List<String> pushTopics;

  String get firstName => name.split(' ').first;

  UserEntity({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.locale,
    required this.sessionToken,
    required this.pushTopics,
  });

  UserEntity copyWith({
    String? name,
    String? locale,
    List<String>? pushTopics,
  }) {
    return UserEntity(
      id: id,
      username: username,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      permissions: permissions,
      locale: locale ?? this.locale,
      sessionToken: sessionToken,
      pushTopics: pushTopics ?? this.pushTopics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': id,
      'username': username,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'permissions': permissions.map((item) => item.name).toList(),
      'locale': locale,
      'sessionToken': sessionToken,
      'pushTopics': pushTopics,
    };
  }
}
