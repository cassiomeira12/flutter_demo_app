abstract class SendWhatsAppCodeUseCase {
  Future<void> call({required String phoneNumber, required String code});
}
