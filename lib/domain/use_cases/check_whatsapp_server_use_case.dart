import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class CheckWhatsAppServerUseCase extends BaseUseCaseAsync {}

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
