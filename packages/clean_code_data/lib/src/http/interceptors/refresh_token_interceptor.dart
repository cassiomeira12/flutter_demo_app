import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class RefreshTokenInterceptor extends Interceptor {
  final UserAuthStorageUseCase _userAuthStorageUseCase;

  RefreshTokenInterceptor({
    required UserAuthStorageUseCase userAuthStorageUseCase,
  }) : _userAuthStorageUseCase = userAuthStorageUseCase;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final networkErros = [DioExceptionType.badResponse];

    if (networkErros.contains(err.type)) {
      final bool hasToken = AppBinding.hasInstance<SessionEntity>();
      if (hasToken) {
        final bool serverError = err.response?.statusCode == 500;
        final session = AppBinding.find<SessionEntity>();
        if (serverError && session.isAuthenticated) {
          Log.warning(
            'Response ERROR ${err.requestOptions.method} \n'
            'path: ${err.requestOptions.uri} \n'
            'status code: ${err.response?.statusCode} \n'
            'body: ${err.response} \n'
            'type: ${err.type}',
          );

          try {
            Log.debug('Refreshing token...');
            final Map<String, dynamic> result = await _refreshToken();

            final UserModel user = UserModel.fromMap(result);
            final String sessionToken = user.sessionToken!;
            final session = SessionEntity(token: sessionToken);

            await _replaceEntityBindings(session: session, user: user);

            final response = await _getRetryRequest(err, sessionToken);
            return handler.resolve(response);
          } catch (_) {
            super.onError(err, handler);
          }
        }
      }
    }

    super.onError(err, handler);
  }

  Future<void> _replaceEntityBindings({
    required SessionEntity session,
    required UserModel user,
  }) async {
    await AppBinding.replace<SessionEntity>(session);
    await AppBinding.replace<UserEntity>(user);

    await _userAuthStorageUseCase.saveSessionToken(session.token!);
    await _userAuthStorageUseCase.saveUserData(user.toMap());
  }

  Future<Map<String, dynamic>> _refreshToken() async {
    final refreshTokenDataSource = AppBinding.find<RefreshTokenDataSource>();
    return await refreshTokenDataSource.refresh();
  }

  Future<Response> _getRetryRequest(DioException err, String token) async {
    final http = AppBinding.find<HttpClient>();

    final request = HttpRequest(
      url: err.requestOptions.path,
      data: err.requestOptions.data,
      queryParameters: err.requestOptions.queryParameters,
    );

    final httpMethod = HttpMethod.fromString(err.requestOptions.method);

    final response = await http.request(
      request,
      method: httpMethod,
      useRefreshTokenInterceptor: false,
    );

    return Response(
      requestOptions: err.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}
