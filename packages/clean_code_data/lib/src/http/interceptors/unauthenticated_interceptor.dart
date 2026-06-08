import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UnauthenticatedInterceptor extends Interceptor with AnalyticsMixin {
  final AppSecurityManager _appSecurityManager;
  final LocalStorageUseCase _localStorageUseCase;

  UnauthenticatedInterceptor({
    required this._appSecurityManager,
    required this._localStorageUseCase,
  });

  static bool ALREADY_LOGOUT = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.badResponse) {
      try {
        if (err.response?.data is String) return super.onError(err, handler);

        final Map<String, dynamic> body = err.response?.data ?? {};

        final errorMessages = [
          'Invalid session token',
          'Session token is expired.',
        ];

        final bool invalidTokenCode = body['code'] == 209;
        final bool invalidTokenError = errorMessages.contains(
          '${body['error']}',
        );

        if (!ALREADY_LOGOUT && invalidTokenCode && invalidTokenError) {
          ALREADY_LOGOUT = true;

          sessionExpiredTagging();

          await SessionHelper.clear();
          await _appSecurityManager.clearSettings();
          await _appSecurityManager.init();

          await _localStorageUseCase.set<bool>(SESSION_WAS_EXPIRED, true);

          AppNavigator.backAllAndToNamed(AppRouter.splash);
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace, msg: 'UnauthenticatedInterceptor');
      }
    }

    return super.onError(err, handler);
  }
}
