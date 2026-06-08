import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/data/services/mixins/mixins.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ErrorPurchaseStatusService
    with HandlerPurchaseErrorMixin
    implements HandlerPurchaseStatusService {
  final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleteManager;

  ErrorPurchaseStatusService({
    required this._appPurchaseRepository,
    required this._futureCompleteManager,
  });

  @override
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    final exception = purchaseError(purchase);

    if (exception is ItemAlreadyOwnedException &&
        _appPurchaseRepository.purchaseProductId != null) {
      final purchaseFounded = _appPurchaseRepository.getPurchaseByProduct(
        _appPurchaseRepository.purchaseProductId!,
      );
      if (purchaseFounded != null) {
        // enviar métrica que usuário tentou comprar um item que já possuia
        return _futureCompleteManager.completerError(exception);
      }
    }

    if (exception is NetworkErrorException) {
      //
    }

    Log.baseException(exception);

    // enviar métrica que ocorreu um erro na compra
    return _futureCompleteManager.completerError(exception);
  }
}
