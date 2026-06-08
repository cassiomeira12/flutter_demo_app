import 'package:core/core.dart';

class UserCanceledException extends BaseException {
  UserCanceledException({
    super.message = 'user_canceled_purchase',
    super.throwReport = false,
  });
}
