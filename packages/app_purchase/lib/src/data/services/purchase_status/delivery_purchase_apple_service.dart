// ignore_for_file: depend_on_referenced_packages

import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class DeliveryPurchaseAppleService implements DeliveryPurchasePlatformService {
  final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleterManager;

  DeliveryPurchaseAppleService({
    required this._appPurchaseRepository,
    required this._futureCompleterManager,
  });

  @override
  Future<void> finishPurchase(PurchaseDetails purchase) async {
    _appPurchaseRepository.savePurchase(purchase);

    if (purchase.status == PurchaseStatus.purchased) {
      _futureCompleterManager.completerSuccess();
    }

    // enviar métrica que compra foi feita com sucesso
    if (purchase is AppStorePurchaseDetails) {
      // purchase.skPaymentTransaction.transactionState;
      Log.success(
        '${purchase.runtimeType} \n',
        // 'developerPayload: ${purchase.skPaymentTransaction.developerPayload} \n'
        // 'isAcknowledged: ${purchase.skPaymentTransaction.isAcknowledged} \n'
        // 'isAutoRenewing: ${purchase.skPaymentTransaction.isAutoRenewing} \n'
        // 'obfuscatedAccountId: ${purchase.skPaymentTransaction.obfuscatedAccountId} \n'
        // 'obfuscatedProfileId: ${purchase.skPaymentTransaction.obfuscatedProfileId} \n'
        // 'orderId: ${purchase.skPaymentTransaction.orderId} \n'
        // 'originalJson: ${purchase.skPaymentTransaction.originalJson} \n'
        // 'packageName: ${purchase.skPaymentTransaction.packageName} \n'
        // 'products: ${purchase.skPaymentTransaction.products.first} \n'
        // 'purchaseToken: ${purchase.skPaymentTransaction.purchaseToken} \n'
        // 'signature: ${purchase.skPaymentTransaction.signature} \n',
        throwsCrashlytics: false,
      );
    }
  }
}
