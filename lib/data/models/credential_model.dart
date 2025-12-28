import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CredentialModel extends CredentialEntity {
  CredentialModel({
    required super.objectId,
    required super.name,
    required super.userName,
    required super.password,
    required super.secretKeyOTP,
    required super.url,
    required super.faviconUrl,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CredentialModel.fromMap(Map<String, dynamic> map) {
    try {
      return CredentialModel(
        objectId: map['objectId'] ?? '',
        name: map['name'] ?? '',
        userName: map['userName'] as String?,
        password: map['password'] as String?,
        secretKeyOTP: map['secretKeyOTP'] as String?,
        url: map['url'] as String?,
        faviconUrl: map['faviconUrl'] as String?,
        notes: map['notes'] as String?,
        createdAt: map['createdAt'] ?? '',
        updatedAt: map['updatedAt'] ?? map['createdAt'] ?? '',
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stacktrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
