import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class OccurrenceModel extends OccurrenceEntity {
  OccurrenceModel({
    required super.objectId,
    required super.latitude,
    required super.longitude,
    required super.accuracy,
    required super.createdAt,
  });

  factory OccurrenceModel.fromMap(Map<String, dynamic> map) {
    try {
      return OccurrenceModel(
        objectId: map['objectId'] ?? '',
        latitude: map['latitude'] ?? 0.0,
        longitude: map['longitude'] ?? 0.0,
        accuracy: map['accuracy'] ?? 0,
        createdAt: map['createdAt'] ?? '',
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
