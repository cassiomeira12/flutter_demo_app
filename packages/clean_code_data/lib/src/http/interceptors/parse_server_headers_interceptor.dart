import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ParseServerHeadersInterceptor extends Interceptor {
  final EnvironmentEntity _environment;

  ParseServerHeadersInterceptor({
    required EnvironmentEntity environment,
  }) : _environment = environment;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? installationId;

    try {
      final getInstallationAppUseCase =
          AppBinding.find<GetInstallationAppUseCase>();
      final installation = await getInstallationAppUseCase.call();
      installationId = installation.installationId;
    } catch (_) {}

    options.headers.addAll({
      'X-Parse-Application-Id': _environment.appId,
      'X-Parse-REST-API-Key': _environment.restApiKey,
      'X-Parse-Installation-Id': installationId,
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
