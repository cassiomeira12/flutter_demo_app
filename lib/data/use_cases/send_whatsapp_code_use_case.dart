import 'package:flutter_demo_app/domain/domain.dart';

class SendWhatsAppCodeUseCaseImpl implements SendWhatsAppCodeUseCase {
  final WhatsAppService _service;

  SendWhatsAppCodeUseCaseImpl({
    required WhatsAppService whatsAppService,
  }) : _service = whatsAppService;

  @override
  Future<void> call({
    required String phoneNumber,
    required String code,
  }) {
    return _service.sendWhatsAppCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}
