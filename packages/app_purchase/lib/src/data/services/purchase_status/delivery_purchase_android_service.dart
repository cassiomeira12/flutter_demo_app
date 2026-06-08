// ignore_for_file: depend_on_referenced_packages

import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class DeliveryPurchaseAndroidService
    implements DeliveryPurchasePlatformService {
  final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleterManager;

  DeliveryPurchaseAndroidService({
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
    if (purchase is GooglePlayPurchaseDetails) {
      // purchase.billingClientPurchase.originalJson;
      Log.success(
        '${purchase.runtimeType} [${purchase.billingClientPurchase.purchaseState.name.toUpperCase()}] \n'
        'obfuscatedAccountId: ${purchase.billingClientPurchase.obfuscatedAccountId} \n'
        'obfuscatedProfileId: [${purchase.billingClientPurchase.obfuscatedProfileId}] \n'
        'orderId: ${purchase.billingClientPurchase.orderId} \n'
        'packageName: ${purchase.billingClientPurchase.packageName} \n'
        'isAutoRenewing: [${purchase.billingClientPurchase.isAutoRenewing}] renovação automática \n'
        'isAcknowledged: [${purchase.billingClientPurchase.isAcknowledged}] reconhecida \n'
        'products: ${purchase.billingClientPurchase.products} \n'
        'purchaseTime: ${purchase.billingClientPurchase.purchaseTime} \n'
        'purchaseToken: ${purchase.billingClientPurchase.purchaseToken} \n'
        'signature: ${purchase.billingClientPurchase.signature} \n'
        'pendingPurchaseUpdate: ${purchase.billingClientPurchase.pendingPurchaseUpdate} \n',
        throwsCrashlytics: false,
      );
    }
  }
}
