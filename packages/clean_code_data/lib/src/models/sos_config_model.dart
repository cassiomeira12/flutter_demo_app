import 'package:core/core.dart';

class SosConfigModel extends SosConfigEntity {
  SosConfigModel({
    required super.onlyPolice,
    required super.onlySafetyContacts,
  });

  factory SosConfigModel.fromMap(Map<String, dynamic> map) {
    try {
      return SosConfigModel(
        onlyPolice: map['onlyPolice'] ?? false,
        onlySafetyContacts: map['onlySafetyContacts'] ?? true,
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
