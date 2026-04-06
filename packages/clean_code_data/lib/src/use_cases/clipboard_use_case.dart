import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ClipboardUseCaseImpl implements ClipboardUseCase {
  @override
  Future<void> copy(
    String text, {
    bool autoClear = false,
    int secondsToClear = 20,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Log.info('Clipboard copy: [$text]');
      if (autoClear) _clearClipboard(secondsToClear);
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<String> paste() async {
    try {
      final ClipboardData? data = await Clipboard.getData('text/plain');
      return data?.text ?? '';
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _clearClipboard(int secondsToClear) async {
    try {
      await Future.delayed(Duration(seconds: secondsToClear));
      await Clipboard.setData(const ClipboardData(text: ''));
      Log.info('Clipboard clearClipboardData');
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }
}
