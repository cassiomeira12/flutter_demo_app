import 'package:app_purchase/src/data/data.dart';

class AvailablePurchaseProductDataSourceImpl
    implements AvailablePurchaseProductDataSource {
  @override
  Future<List<Map<String, dynamic>>> list() async {
    return [
      {
        'id': 'fake',
        'title': 'fake',
        'consumableProduct': true,
      },
      {
        'id': 'uol_conteudo_anual_parc_11880',
        'title': '12x de {price}',
        'consumableProduct': false,
      },
      {
        'id': 'uol_conteudo_exclusivo_mensal_1990',
        'title': '{price}/mês',
        'consumableProduct': false,
      },
    ];
  }
}
