abstract class ClipboardUseCase {
  Future<void> copy(String text);

  Future<String> paste();
}
