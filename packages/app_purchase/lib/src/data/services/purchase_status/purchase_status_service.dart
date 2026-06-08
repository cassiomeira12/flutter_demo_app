import 'package:app_purchase/src/data/data.dart';
import 'package:app_purchase/src/data/services/mixins/mixins.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PurchasedStatusService
    with HandlerPurchaseErrorMixin
    implements HandlerPurchaseStatusService {
  final PurchaseValidationService _purchaseValidationService;
  final DeliveryPurchasePlatformService _deliveryPurchaseService;
  final InvalidPurchaseService _invalidPurchaseService;

  PurchasedStatusService({
    required this._purchaseValidationService,
    required this._deliveryPurchaseService,
    required this._invalidPurchaseService,
  });

  @override
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    final isValid = await _purchaseValidationService.verify(
      purchaseID: purchase.purchaseID,
      productID: purchase.productID,
      serverVerificationData: purchase.verificationData.serverVerificationData,
    );
    if (isValid is Success) {
      _deliveryPurchaseService.finishPurchase(purchase);
    } else {
      _invalidPurchaseService.handlePurchase(purchase);
    }
  }
}
