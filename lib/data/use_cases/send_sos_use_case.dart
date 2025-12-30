import 'package:flutter_demo_app/domain/domain.dart';

class SendSosUseCaseImpl implements SendSosUseCase {
  final EmergencyService _service;

  SendSosUseCaseImpl({
    required EmergencyService emergencyService,
  }) : _service = emergencyService;

  @override
  Future<int> call({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  }) async {
    return await _service.sendSOS(
      choice: choice,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
    );
  }
}
