import '../../core/core.dart';
import '../../domain/domain.dart';
import '../app_router.dart';

class SplashController extends BaseController {
  @override
  Future<void> onReady() async {
    super.onReady();
    String appName = const String.fromEnvironment('app_name');
    String appId = const String.fromEnvironment('app_id');
    String clientKey = const String.fromEnvironment('client_key');
    String restApiKey = const String.fromEnvironment('rest_api_key');
    String serverUrl = const String.fromEnvironment('server_url');
    String graphqllUrl = const String.fromEnvironment('graphql_url');

    AppBinding.put<EnvironmentEntity>(
      EnvironmentEntity(
        appName: appName,
        appId: appId,
        clientKey: clientKey,
        restApiKey: restApiKey,
        serverUrl: serverUrl,
        graphqllUrl: graphqllUrl,
      ),
      permanent: true,
    );

    // AppBindings().dependencies();

    await Future.delayed(const Duration(seconds: 1));

    AppRouter.backAllAndToNamed(AppRouter.home);
  }
}
