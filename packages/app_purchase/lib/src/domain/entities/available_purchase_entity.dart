class AvailablePurchaseEntity {
  final String id;
  final String title;
  final bool consumableProduct;

  AvailablePurchaseEntity({
    required this.id,
    required this.title,
    required this.consumableProduct,
  });

  @override
  String toString() {
    return '$runtimeType(\n'
        'id: $id \n'
        'title: $title \n'
        'consumableProduct: $consumableProduct)';
  }
}
