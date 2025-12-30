import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class EmergencyService {
  Future<bool> isAvailable();

  Future<int> sendSOS({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  });

  Future<List<OccurrenceEntity>> listHistory();

  Future<SosConfigEntity> changeSOSConfig({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  });
}
