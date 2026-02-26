abstract class ClipboardUseCase {
  Future<void> copy(String text, {bool autoClear = false});

  Future<String> paste();
}
