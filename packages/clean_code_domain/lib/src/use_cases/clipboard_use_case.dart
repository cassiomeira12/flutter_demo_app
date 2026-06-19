import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class ClipboardUseCase extends UseCase {
  Future<void> copy(String text, {bool autoClear = false});

  Future<String> paste();
}

class ClipboardUseCaseImpl implements ClipboardUseCase {
  final ClipboardService _clipboardService;

  ClipboardUseCaseImpl({required this._clipboardService});

  @override
  Future<void> copy(
    String text, {
    bool autoClear = false,
    int secondsToClear = 20,
  }) async {
    return _clipboardService.copy(
      text,
      autoClear: autoClear,
      secondsToClear: secondsToClear,
    );
  }

  @override
  Future<String> paste() {
    return _clipboardService.paste();
  }
}
