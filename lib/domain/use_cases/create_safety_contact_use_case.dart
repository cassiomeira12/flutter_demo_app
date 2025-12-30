import 'package:flutter_demo_app/domain/domain.dart';

abstract class CreateSafetyContactUseCase {
  Future<SafetyContactEntity> call({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  });
}
