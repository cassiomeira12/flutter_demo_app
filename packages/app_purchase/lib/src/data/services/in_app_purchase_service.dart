import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class InAppPurchaseServiceImpl implements InAppPurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _inAppPurchase.isAvailable();
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> buyConsumable(PurchaseParam param) async {
    try {
      return await _inAppPurchase.buyConsumable(purchaseParam: param);
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> buyNonConsumable(PurchaseParam param) async {
    try {
      return await _inAppPurchase.buyNonConsumable(purchaseParam: param);
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> restorePurchases(String userIdentifierId) async {
    try {
      return await _inAppPurchase.restorePurchases(
        applicationUserName: userIdentifierId,
      );
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    try {
      await _inAppPurchase.completePurchase(purchase);
      Log.success('completePurchase ${purchase.purchaseID}');
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<ProductDetailsResponse> queryProducts(Iterable<String> ids) async {
    try {
      return await _inAppPurchase.queryProductDetails(ids.toSet());
    } on InAppPurchaseException catch (error) {
      throw BaseException(
        message: error.toString(),
        stackTrace: StackTrace.current,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
