import 'package:core/core.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.permissions,
    required super.locale,
    required super.sessionToken,
    required super.pushTopics,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      final String? name = map['name'] ?? map['nome'];
      final String firstName = (name ?? '').split(' ').first;
      final String avatarUrl =
          'https://ui-avatars.com/api/?format=png&name=$firstName';

      return UserModel(
        id: map['objectId'] ?? map['id'],
        username: map['username'] ?? map['email'],
        name: map['name'] ?? map['nome'],
        email: map['email'] ?? map['username'],
        avatarUrl: map['avatarUrl'] ?? avatarUrl,
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        permissions: List.from(map['permissions'] ?? []).map((permission) {
          return UserPermissionsEnum.values.firstWhere((item) {
            final String permissionFormatted = permission
                .toString()
                .split('-')
                .first;
            final String userPermission = permissionFormatted.toLowerCase();
            final String enumPermission = item.name.toLowerCase();
            return userPermission == enumPermission;
          }, orElse: () => UserPermissionsEnum.USER);
        }).toList(),
        locale: map['locale'],
        sessionToken: map['sessionToken'] ?? map['token'],
        pushTopics: List.from(map['pushTopics'] ?? []),
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
