import 'package:core/core.dart';

class ServerUnavailableException extends BaseException {
  ServerUnavailableException({
    super.message = 'server_unavailable_service',
    super.throwReport = false,
  });
}
