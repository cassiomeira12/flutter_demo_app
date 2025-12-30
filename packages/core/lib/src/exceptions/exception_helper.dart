// abstract class ExceptionHelper {
//   static BaseException call(HttpException error, {StackTrace? stackTrace}) {
//     int? statusCode;
//     if (error.data == null) {
//       statusCode = error.statusCode;
//     } else {
//       if (error.data is Map<String, dynamic>) {
//         statusCode = error.data['code'] as int?;
//       } else {
//         statusCode = error.statusCode;
//       }
//     }
//     switch (statusCode) {
//       case -1:
//         throw NoInternetException();
//       case 101:
//         throw AuthUserException();
//       case 142:
//         throw BaseException(message: '');
//       case 202:
//         throw BaseException(message: 'account_already_exists_error');
//       case 204:
//         throw BaseException();
//       case 209:
//         throw InvalidTokenException();
//       case 400:
//         throw BaseException(message: error.data);
//       case 403:
//         throw BaseException();
//       default:
//         Log.error(
//           'Unexpected Http Exception',
//           error: error,
//           stackTrace: stackTrace,
//         );
//         throw BaseException(
//           message: '${error.data}',
//           error: error,
//           stacktrace: stackTrace,
//         );
//     }
//   }
// }
