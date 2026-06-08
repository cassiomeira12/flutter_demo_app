import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/data/services/mixins/mixins.dart';
import 'package:app_purchase/src/data/services/services.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';

class PurchaseListenerUpdatesServiceImpl
    with LogPurchaseMixin
    implements PurchaseListenerUpdatesService {
  final InAppPurchaseService _inAppPurchaseService;
  final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleterManager;
  final PurchasedStatusService _purchasedStatusService;
  final PendingPurchaseStatusService _pendingPurchaseStatusService;
  final CanceledPurchaseStatusService _canceledPurchaseStatusService;
  final ErrorPurchaseStatusService _errorPurchaseStatusService;

  PurchaseListenerUpdatesServiceImpl({
    required this._inAppPurchaseService,
    required this._appPurchaseRepository,
    required this._futureCompleterManager,
    required this._purchasedStatusService,
    required this._pendingPurchaseStatusService,
    required this._canceledPurchaseStatusService,
    required this._errorPurchaseStatusService,
  });

  @override
  Future<void> onListener(List<PurchaseDetails> list) async {
    for (final purchase in list) {
      logPurchase(purchase);
      switch (purchase.status) {
        case PurchaseStatus.pending:
          await _pendingPurchaseStatusService.handlePurchase(purchase);
        case PurchaseStatus.canceled:
          await _canceledPurchaseStatusService.handlePurchase(purchase);
          continue;
        case PurchaseStatus.error:
          await _errorPurchaseStatusService.handlePurchase(purchase);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _purchasedStatusService.handlePurchase(purchase);
      }
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchaseService.completePurchase(purchase);
      }
    }

    if (!_futureCompleterManager.isFutureCompleted) {
      _appPurchaseRepository.updatePurchaseStatus(list);
      _futureCompleterManager.completerSuccess();
    }
  }
}
