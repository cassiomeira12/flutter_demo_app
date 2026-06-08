import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/data/services/mixins/mixins.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CanceledPurchaseStatusService
    with HandlerPurchaseErrorMixin
    implements HandlerPurchaseStatusService {
  final FutureCompleterManager _futureCompleterManager;

  CanceledPurchaseStatusService({
    required FutureCompleterManager futureCompleteManager,
  }) : _futureCompleterManager = futureCompleteManager;

  @override
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    final exception = purchaseError(purchase);
    if (exception is UserCanceledException) {
      if (Platform.appleDevice) {
        // necessary complete all canceled purchase on iOS
        return _futureCompleterManager.completerSuccess();
      }
    }
    // enviar métrica que usuário cancelou a compra
    return _futureCompleterManager.completerError(exception);
  }
}
