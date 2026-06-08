import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class FutureCompleterManager {
  Completer? _functionCompleter;
  String? _purchaseProductId;

  String? get purchaseProductId => _purchaseProductId;

  bool get isFutureCompleted => _functionCompleter?.isCompleted ?? true;

  Completer startFutureFunction({String? purchaseProductId}) {
    _functionCompleter?.complete();
    _purchaseProductId = purchaseProductId;
    return _functionCompleter = Completer();
  }

  void completerError(BaseException error) {
    _functionCompleter?.completeError(error);
    _functionCompleter = null;
    _purchaseProductId = null;
  }

  void completerSuccess() {
    _functionCompleter?.complete();
    _functionCompleter = null;
    _purchaseProductId = null;
  }
}
