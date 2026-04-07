import 'package:core/core.dart';

class CredentialEntity extends BaseEntity {
  final String name;
  final String? userName;
  final String? password;
  final String? secretKeyOTP;
  final String? url;
  final String? faviconUrl;
  final String? notes;

  CredentialEntity({
    required super.objectId,
    required this.name,
    required this.userName,
    required this.password,
    required this.secretKeyOTP,
    required this.url,
    required this.faviconUrl,
    required this.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  CredentialEntity copyWith({
    String? objectId,
    String? name,
    String? userName,
    String? password,
    String? secretKeyOTP,
    String? url,
    String? faviconUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CredentialEntity(
      objectId: objectId ?? this.objectId,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      secretKeyOTP: secretKeyOTP ?? this.secretKeyOTP,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? super.createdAt,
      updatedAt: updatedAt ?? super.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userName': userName,
      'password': password,
      'secretKeyOTP': secretKeyOTP,
      'url': url,
      'faviconUrl': faviconUrl,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      ...super.toMap(),
    };
  }

  String get favIconUrlFormatted =>
      faviconUrl ?? 'https://ui-avatars.com/api/?format=png&name=$name';
}
