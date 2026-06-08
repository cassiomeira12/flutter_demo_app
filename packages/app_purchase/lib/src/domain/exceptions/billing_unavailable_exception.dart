import 'package:core/core.dart';

class BillingUnavailableException extends BaseException {
  BillingUnavailableException({
    super.message = 'purchase_billing_unavailable',
  });
}
