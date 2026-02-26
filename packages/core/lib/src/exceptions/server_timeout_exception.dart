import 'package:core/core.dart';

class ServerTimeoutException extends BaseException {
  ServerTimeoutException({
    super.message = 'server_timeout_response',
    super.throwReport = false,
  });
}
