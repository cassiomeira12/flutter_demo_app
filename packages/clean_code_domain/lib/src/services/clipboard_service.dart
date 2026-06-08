abstract class ClipboardService {
  Future<void> copy(
    String text, {
    bool autoClear = false,
    int secondsToClear = 20,
  });

  Future<String> paste();
}
