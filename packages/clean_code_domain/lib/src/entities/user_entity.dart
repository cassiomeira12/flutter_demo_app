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
  final String? phoneNumber;
  final bool? phoneVerified;

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
    required this.phoneNumber,
    required this.phoneVerified,
  });

  UserEntity copyWith({
    String? name,
    String? phoneNumber,
    bool? phoneVerified,
    String? locale,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneVerified: phoneVerified ?? this.phoneVerified,
    );
  }

  String get firstName {
    return name.split(' ').first;
  }

  // String get phoneNumberWithoutCountry {
  //   if (phoneNumber.isNotEmpty) {
  //     return '(${phoneNumber.split('(').last.trim()}';
  //   }
  //   return phoneNumber;
  // }

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
      'phoneNumber': phoneNumber,
      'phoneVerified': phoneVerified,
    };
  }
}

// import 'package:dependency/dependency.dart';

// class UserEntity {
//   final String id;
//   final String name;
//   final String email;
//   final String avatarUrl;
//   final String? sessionToken;

//   UserEntity({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.avatarUrl,
//     required this.sessionToken,
//   });

//   UserEntity copyWith({
//     String? name,
//     String? phoneNumber,
//     bool? phoneVerified,
//     String? locale,
//   }) {
//     return UserEntity(
//       id: id,
//       name: name ?? this.name,
//       email: email,
//       avatarUrl: avatarUrl,
//       sessionToken: sessionToken,
//     );
//   }

//   String get firstName {
//     return name.split(' ').first;
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'nome': name,
//       'email': email,
//       'avatarUrl': avatarUrl,
//       'token': sessionToken,
//     };
//   }

//   String get locale {
//     return Get.locale.toString();
//   }
// }
