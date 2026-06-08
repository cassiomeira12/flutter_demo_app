import 'package:core/core.dart';

class ItemAlreadyOwnedException extends BaseException {
  ItemAlreadyOwnedException({
    super.message = 'user_already_has_subscription_purchased',
    super.throwReport = false,
  });
}
