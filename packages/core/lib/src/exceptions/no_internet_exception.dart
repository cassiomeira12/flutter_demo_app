import 'package:core/core.dart';

class NoInternetException extends BaseException {
  NoInternetException({
    super.message = 'internet_error_connection',
    super.throwReport = false,
  });
}
