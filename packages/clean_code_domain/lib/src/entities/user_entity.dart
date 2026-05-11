import 'package:clean_code_domain/clean_code_domain.dart';

class UserEntity extends ParserToJson {
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
  final String phoneNumber;
  final bool? phoneVerified;
  final SosConfigEntity sosConfig;

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
    required this.phoneNumber,
    required this.phoneVerified,
    required this.sosConfig,
  });

  UserEntity copyWith({
    String? name,
    String? locale,
    List<String>? pushTopics,
    String? phoneNumber,
    bool? phoneVerified,
    SosConfigEntity? sosConfig,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      sosConfig: sosConfig ?? this.sosConfig,
    );
  }

  String get phoneNumberWithoutCountry {
    if (phoneNumber.isNotEmpty) {
      return '(${phoneNumber.split('(').last.trim()}';
    }
    return phoneNumber;
  }

  SosChoiceEnum get sosConfigChoice {
    if (sosConfig.onlyPolice && sosConfig.onlySafetyContacts) {
      return SosChoiceEnum.ALL;
    }
    if (sosConfig.onlyPolice) {
      return SosChoiceEnum.POLICY_ONLY;
    }
    if (sosConfig.onlySafetyContacts) {
      return SosChoiceEnum.SAFETY_CONTACTS_ONLY;
    }
    return SosChoiceEnum.SAFETY_CONTACTS_ONLY;
  }

  @override
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
      'phoneNumber': phoneNumber,
      'phoneVerified': phoneVerified,
      'sosConfig': sosConfig.toMap(),
    };
  }
}
