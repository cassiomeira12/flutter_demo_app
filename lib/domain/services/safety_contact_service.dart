import 'package:flutter_demo_app/domain/domain.dart';

abstract class SafetyContactService {
  Future<SafetyContactEntity> create({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  });

  Future<List<SafetyContactEntity>> list(int page);

  Future<bool> delete(String objectId);
}
