import 'package:app_purchase/src/domain/domain.dart';

abstract class AppPurchaseService {
  Stream<List<PurchaseDetailsEntity>> get userPurchases;

  Future<void> init({required String userIdentifierId});

  void close();

  Future<bool> isServiceAvailable();

  Future<void> buyProduct(PurchaseProductEntity product);

  Future<void> buySubscription(
    PurchaseSubscriptionEntity subscription,
  );

  Future<void> updateSubscription({
    required PurchaseDetailsEntity oldSubscription,
    required PurchaseSubscriptionEntity newSubscription,
  });

  Future<List<PurchaseEntity>> queryProductDetails(
    List<AvailablePurchaseEntity> products,
  );

  Future<void> restorePurchases();
}
