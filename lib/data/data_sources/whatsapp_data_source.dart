abstract class WhatsAppDataSource {
  Future<void> sendWhatsAppCode({
    required String phoneNumber,
    required String code,
  });
}
