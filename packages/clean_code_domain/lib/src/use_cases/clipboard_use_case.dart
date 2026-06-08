import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class ClipboardUseCase extends UseCase {
  Future<void> copy(String text, {bool autoClear = false});

  Future<String> paste();
}

class ClipboardUseCaseImpl implements ClipboardUseCase {
  final ClipboardService _service;

  ClipboardUseCaseImpl({
    required ClipboardService clipboardService,
  }) : _service = clipboardService;

  @override
  Future<void> copy(
    String text, {
    bool autoClear = false,
    int secondsToClear = 20,
  }) async {
    return _service.copy(
      text,
      autoClear: autoClear,
      secondsToClear: secondsToClear,
    );
  }

  @override
  Future<String> paste() {
    return _service.paste();
  }
}
