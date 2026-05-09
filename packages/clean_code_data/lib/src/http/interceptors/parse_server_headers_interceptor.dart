import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ParseServerHeadersInterceptor extends Interceptor {
  final ServerEnvironmentEntity _serverEnv;

  ParseServerHeadersInterceptor({
    required ServerEnvironmentEntity serverEnv,
  }) : _serverEnv = serverEnv;

  InstallationEntity? _installationEntity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      'X-Parse-Application-Id': _serverEnv.appId,
      'X-Parse-REST-API-Key': _serverEnv.restApiKey,
      'X-Parse-Installation-Id': await _getInstallationId(),
    });

    // Add ClientKey only for Non Web App
    if (!Platform.isWeb) {
      options.headers.addAll({'X-Parse-Client-Key': _serverEnv.clientKey});
    }

    super.onRequest(options, handler);
  }

  Future<String?> _getInstallationId() async {
    if (_installationEntity != null) {
      return _installationEntity?.installationId;
    }

    try {
      if (AppBinding.hasInstance<GetInstallationAppUseCase>()) {
        final installationApp = AppBinding.find<GetInstallationAppUseCase>();
        _installationEntity = await installationApp.call();
        return _installationEntity?.installationId;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
