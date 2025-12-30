import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class SafetyContactModel extends SafetyContactEntity {
  SafetyContactModel({
    required super.objectId,
    required super.name,
    required super.phoneNumber,
    required super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SafetyContactModel.fromMap(Map<String, dynamic> map) {
    try {
      return SafetyContactModel(
        objectId: map['objectId'] ?? '',
        name: map['name'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        avatarUrl: map['avatarUrl'] ?? '',
        createdAt: map['createdAt'] ?? '',
        updatedAt: map['updatedAt'] ?? '',
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
