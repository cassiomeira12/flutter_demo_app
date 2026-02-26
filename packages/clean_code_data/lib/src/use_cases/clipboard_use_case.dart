import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class ClipboardUseCaseImpl implements ClipboardUseCase {
  @override
  Future<void> copy(String text, {bool autoClear = false}) async {
    await Clipboard.setData(ClipboardData(text: text));
    // After 10s clear clipboard text for security
    if (autoClear) {
      Future.delayed(
        const Duration(seconds: 10),
        () => Clipboard.setData(const ClipboardData(text: '')),
      );
    }
  }

  @override
  Future<String> paste() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text ?? '';
  }
}
