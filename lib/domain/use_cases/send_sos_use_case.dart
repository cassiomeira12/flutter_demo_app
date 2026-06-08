import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class SendSosUseCase extends UseCase {
  Future<int> call({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  });
}

class SendSosUseCaseImpl implements SendSosUseCase {
  final EmergencyService _emergencyService;

  SendSosUseCaseImpl({required this._emergencyService});

  @override
  Future<int> call({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  }) {
    return _emergencyService.sendSOS(
      choice: choice,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
    );
  }
}
