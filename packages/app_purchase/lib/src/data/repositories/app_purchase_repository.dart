import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';

class AppPurchaseRepositoryImpl implements AppPurchaseRepository {
  AppPurchaseRepositoryImpl();

  String? _purchaseProductId;
  @override
  String? get purchaseProductId => _purchaseProductId;

  final Map<String, ProductDetails> _productsDetails = {};
  final Map<String, PurchaseDetails> _purchaseDetails = {};
  final Map<String, PurchaseDetailsEntity> _purchaseStore = {};

  final _userPurchaseStream = StreamController<List<PurchaseDetailsEntity>>();

  @override
  Map<String, ProductDetails> get productsDetailsMap => _productsDetails;

  @override
  void setProductsDetails(List<ProductDetails> products) {
    for (final product in products) {
      _productsDetails[product.id] = product;
    }
  }

  @override
  Stream<List<PurchaseDetailsEntity>> get userPurchases =>
      _userPurchaseStream.stream;

  @override
  void setPurchaseInProgress({String? productId}) =>
      _purchaseProductId = productId;

  @override
  PurchaseDetails? getPurchaseByProduct(String productId) {
    final founded = _purchaseDetails.values.where(
      (purchase) => purchase.productID == productId,
    );
    return founded.isNotEmpty ? founded.first : null;
  }

  @override
  PurchaseDetails? getPurchaseDetails(String purchaseID) {
    return _purchaseDetails[purchaseID];
  }

  @override
  PurchaseDetailsEntity? getPurchaseDetailsEntity(String purchaseID) {
    return _purchaseStore[purchaseID];
  }

  @override
  void savePurchase(PurchaseDetails purchase) {
    _purchaseDetails[purchase.purchaseID!] = purchase;
    _purchaseStore[purchase.purchaseID!] = parsePurchaseDetails(purchase);
    _userPurchaseStream.add(_purchaseStore.values.toList());
  }

  PurchaseDetailsEntity parsePurchaseDetails(PurchaseDetails purchase) {
    final verificationData = purchase.verificationData;
    final createdAt = purchase.transactionDate?.trim().isEmpty ?? false
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(purchase.transactionDate!),
          );
    return PurchaseDetailsEntity(
      objectId: faker.guid.guid(),
      purchaseID: purchase.purchaseID,
      productId: purchase.productID,
      source: verificationData.source,
      localVerificationData: verificationData.localVerificationData,
      serverVerificationData: verificationData.serverVerificationData,
      createdAt: createdAt,
      updatedAt: createdAt,
      prouctPrice: _productsDetails[purchase.productID]!.price,
      cancelled: false,
    );
  }

  @override
  void removePurchase(String purchaseID) {
    _purchaseDetails.remove(purchaseID);
    _purchaseStore.remove(purchaseID);
  }

  @override
  void updatePurchaseStatus(List<PurchaseDetails> updatePurchaseList) {
    final List<String> updatedPurchases = updatePurchaseList
        .where((item) => item.purchaseID != null)
        .map((item) => item.purchaseID!)
        .toList();
    for (final purchase in _purchaseStore.values) {
      if (!updatedPurchases.contains(purchase.purchaseID)) {
        _purchaseStore[purchase.purchaseID!] = purchase.copyWith(
          cancelled: true,
        );
      }
    }
    for (final purchase in updatePurchaseList) {
      _purchaseDetails[purchase.purchaseID!] = purchase;
    }
    _userPurchaseStream.add(_purchaseStore.values.toList());
  }
}
