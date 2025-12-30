import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

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
