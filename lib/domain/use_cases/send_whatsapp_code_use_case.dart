import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class SendWhatsAppCodeUseCase extends UseCase {
  Future<void> call({
    required String phoneNumber,
    required String code,
  });
}

class SendWhatsAppCodeUseCaseImpl implements SendWhatsAppCodeUseCase {
  final WhatsAppService _whatsAppService;

  SendWhatsAppCodeUseCaseImpl({required this._whatsAppService});

  @override
  Future<void> call({
    required String phoneNumber,
    required String code,
  }) {
    return _whatsAppService.sendWhatsAppCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}
