// ignore_for_file: depend_on_referenced_packages

import 'package:dependency/dependency.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

mixin UpdateAndroidPurchaseSubscriptionMixin {
  Future<PurchaseParam> parseUpdateAndroidSubscription({
    required PurchaseDetails oldSubscription,
    required ProductDetails newSubscription,
    String? applicationUserName,
  }) async {
    return GooglePlayPurchaseParam(
      productDetails: newSubscription,
      changeSubscriptionParam: ChangeSubscriptionParam(
        oldPurchaseDetails: oldSubscription as GooglePlayPurchaseDetails,
        replacementMode: .withTimeProration,
      ),
      applicationUserName: applicationUserName,
    );
  }
}
