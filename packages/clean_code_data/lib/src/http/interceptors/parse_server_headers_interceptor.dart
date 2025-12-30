import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ParseServerHeadersInterceptor extends Interceptor {
  final EnvironmentEntity _environment;
  final GetInstallationAppUseCase _getInstallationAppUseCase;

  ParseServerHeadersInterceptor({
    required EnvironmentEntity environment,
    required GetInstallationAppUseCase getInstallationAppUseCase,
  }) : _environment = environment,
       _getInstallationAppUseCase = getInstallationAppUseCase;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? instalationId;

    try {
      final installation = await _getInstallationAppUseCase.call();
      instalationId = installation.installationId;
    } catch (_) {}

    options.headers.addAll({
      'X-Parse-Application-Id': _environment.appId,
      'X-Parse-REST-API-Key': _environment.restApiKey,
      'X-Parse-Installation-Id': instalationId,
    });

    // Add ClientKey only for Non Web App
    options.headers.addIf(
      !Platform.isWeb,
      'X-Parse-Client-Key',
      _environment.clientKey,
    );

    super.onRequest(options, handler);
  }
}
