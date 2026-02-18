import 'package:core/core.dart';

abstract class ExceptionHelper {
  static BaseException call(HttpException error, {StackTrace? stackTrace}) {
    int? statusCode;
    if (error.data == null) {
      statusCode = error.statusCode;
    } else {
      if (error.data is Map<String, dynamic>) {
        statusCode = error.data['code'] as int?;
      } else {
        statusCode = error.statusCode;
      }
    }

    Log.warning(
      'statusCode: $statusCode \n'
      'message: ${error.message} \n'
      'statusMessage: ${error.statusMessage} \n'
      'data: ${error.data}',
    );

    switch (statusCode) {
      case -1:
        throw NoInternetException();
      case 101:
        throw AuthUserException();
      case 142:
        throw BaseException(message: 'default_error');
      case 202:
        throw BaseException(message: 'account_already_exists_error');
      case 204:
        throw BaseException();
      case 209:
        throw InvalidTokenException();
      case 400:
        throw BaseException(message: error.data);
      case 401:
        throw InvalidTokenException();
      case 403:
        throw ForbiddenException();
      case 404:
        throw NotFoundException();
      case 451:
        throw LegalReasonsException();
      case 500:
        throw ServerInternalException();
      case 502:
      case 503:
        throw ServerUnavailableException();
      case 504:
        throw ServerTimeoutException();
      default:
        Log.error(
          'Unexpected Http Exception',
          error: error,
          stackTrace: stackTrace,
        );
        throw BaseException(
          message: 'default_error',
          error: error,
          stackTrace: stackTrace,
        );
    }
  }
}
