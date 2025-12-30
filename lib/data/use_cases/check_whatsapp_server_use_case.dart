import 'package:flutter_demo_app/domain/domain.dart';

class CheckWhatsAppServerUseCaseImpl implements CheckWhatsAppServerUseCase {
  final EmergencyService _service;

  CheckWhatsAppServerUseCaseImpl({
    required EmergencyService emergencyService,
  }) : _service = emergencyService;

  @override
  Future<bool> call() async {
    return await _service.isAvailable();
  }
}
