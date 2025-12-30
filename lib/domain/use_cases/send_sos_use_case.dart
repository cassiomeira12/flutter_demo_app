abstract class SendSosUseCase {
  Future<int> call({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  });
}
