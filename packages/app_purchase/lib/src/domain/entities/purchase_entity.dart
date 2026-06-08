class PurchaseEntity {
  final String id;
  final String productTitle;
  final String purchaseTitle;
  final String purhcaseDescription;
  final String price;
  final double rawPrice;
  final String currencyCode;
  final String currencySymbol;

  PurchaseEntity({
    required this.id,
    required this.productTitle,
    required this.purchaseTitle,
    required this.purhcaseDescription,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.currencySymbol,
  });

  String get title {
    return productTitle.replaceAll('{price}', price);
  }
}
