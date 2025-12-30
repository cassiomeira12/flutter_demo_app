// ignore_for_file: non_constant_identifier_names

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UnauthenticatedInterceptor extends Interceptor {
  final UserAuthStorageUseCase _authStorageUseCase;
  final PushMessagingService _pushMessagingService;
  final AppSecurityManager _appSecurityManager;

  UnauthenticatedInterceptor({
    required UserAuthStorageUseCase authStorageUseCase,
    required PushMessagingService messagingService,
    required AppSecurityManager appSecurityManager,
  }) : _authStorageUseCase = authStorageUseCase,
       _pushMessagingService = messagingService,
       _appSecurityManager = appSecurityManager;

  static bool ALREADY_LOGOUT = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.badResponse) {
      try {
        // final Map<String, dynamic> body = err.response?.data ?? {};

        // final errorMessages = [
        //   'Invalid session token',
        //   'Session token is expired.',
        // ];

        // bool invalidTokenCode = body['code'] == 209;
        // bool invalidTokenError = errorMessages.contains('${body['error']}');

        final bool serverError = err.response?.statusCode == 500;

        if (!ALREADY_LOGOUT && serverError) {
          ALREADY_LOGOUT = true;

          try {
            final userData = await _authStorageUseCase.getUserData();
            if (userData != null) {
              final user = UserModel.fromMap(userData);
              await _pushMessagingService.unsubscribeTopic(user.id);
            }
          } catch (error, stacktrace) {
            Log.error(
              'UnauthenticatedInterceptor',
              error: error,
              stackTrace: stacktrace,
            );
          }

          await SessionHelper.clear();
          await _appSecurityManager.clearSettings();
          await _appSecurityManager.init();

          AppNavigator.backAllAndToNamed(AppRouter.splash);

          // Future.delayed(
          //   const Duration(seconds: 1),
          // ).whenComplete(SnackBarWidget.showUnauthenticatedSession);
        }
      } catch (error, stacktrace) {
        Log.error(
          'UnauthenticatedInterceptor',
          error: error,
          stackTrace: stacktrace,
        );
      }
    }

    return super.onError(err, handler);
  }
}
