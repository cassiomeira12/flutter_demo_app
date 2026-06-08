import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class CreateSafetyContactUseCase extends UseCase {
  Future<SafetyContactEntity> call({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  });
}

class CreateSafetyContactUseCaseImpl implements CreateSafetyContactUseCase {
  final SafetyContactService _service;

  CreateSafetyContactUseCaseImpl({
    required SafetyContactService safetyContactService,
  }) : _service = safetyContactService;

  @override
  Future<SafetyContactModel> call({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  }) async {
    final safetyContact = await _service.create(
      name: name,
      phoneNumber: phoneNumber,
      sendMessage: sendMessage,
    );

    return safetyContact as SafetyContactModel;
  }
}
