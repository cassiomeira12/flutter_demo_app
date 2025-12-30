abstract class WhatsAppService {
  Future<void> sendWhatsAppCode({
    required String phoneNumber,
    required String code,
  });
}
