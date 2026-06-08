import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class InvalidPurchaseService implements HandlerPurchaseStatusService {
  // final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleterManager;

  InvalidPurchaseService({
    // required AppPurchaseRepository appPurchaseRepository,
    required this._futureCompleterManager,
  });

  @override
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    // _appPurchaseRepository.removePurchase(purchase.purchaseID);
    // enviar métrica que a compra ficou inválida
    _futureCompleterManager.completerError(
      BaseException(message: 'invalid purchase'),
    );
  }
}
