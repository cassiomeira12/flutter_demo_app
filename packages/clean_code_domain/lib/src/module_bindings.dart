import 'package:core/core.dart';

class DomainModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.put<EnvironmentEntity>(
      EnvironmentEntity(
        appName: const String.fromEnvironment('app_name'),
        serverUrl: const String.fromEnvironment('server_url'),
        appId: const String.fromEnvironment('app_id'),
        clientKey: const String.fromEnvironment('client_key'),
        restApiKey: const String.fromEnvironment('rest_api_key'),
        graphqlUrl: const String.fromEnvironment('graphql_url'),
      ),
      permanent: true,
    );
  }
}
