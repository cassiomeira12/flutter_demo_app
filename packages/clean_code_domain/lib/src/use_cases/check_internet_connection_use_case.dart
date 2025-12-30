abstract class CheckInternetConnectionUseCase {
  Future<bool> call();

  Stream<bool> get internetStream;

  void pauseStream();

  void resumeStream();

  void dispose();
}
