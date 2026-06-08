import 'package:core/core.dart';

class ItemUnavailableException extends BaseException {
  ItemUnavailableException({
    super.message = 'purchase_product_unavailable',
  });
}
