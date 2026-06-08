import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:clean_code_infra/src/data_sources/data_sources.dart';
import 'package:clean_code_infra/src/http/http.dart';
import 'package:clean_code_infra/src/http/interceptors/interceptors.dart';
import 'package:core/core.dart';

class InfraModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<AppEnvironmentEntity>(
      AppEnvironmentEntity(
        appName: const String.fromEnvironment('app_name'),
        androidPackageName: const String.fromEnvironment(
          'android_package_name',
        ),
        appleStoreAppId: const String.fromEnvironment('apple_store_app_id'),
        permissions: const String.fromEnvironment('permissions'),
      ),
      permanent: true,
    );

    AppBinding.put<SecurityEnvironmentEntity>(
      SecurityEnvironmentEntity(
        encryptKey: const String.fromEnvironment('encrypter_key'),
        serverRSAPublicKeyBase64: const String.fromEnvironment(
          'serverRSAPublicKeyBase64',
        ),
        secretOTP: const String.fromEnvironment('server_secret_otp'),
      ),
      permanent: true,
    );

    AppBinding.put<ServerEnvironmentEntity>(
      ServerEnvironmentEntity(
        serverUrl: const String.fromEnvironment('server_url'),
        appId: const String.fromEnvironment('app_id'),
        clientKey: const String.fromEnvironment('client_key'),
        restApiKey: const String.fromEnvironment('rest_api_key'),
        graphqlUrl: const String.fromEnvironment('graphql_url'),
      ),
      permanent: true,
    );

    AppBinding.put<WebAppEnvironmentEntity>(
      WebAppEnvironmentEntity(
        contactEmail: const String.fromEnvironment('web_contact_email'),
        contactFacebook: const String.fromEnvironment('web_contact_facebook'),
        contactInstagram: const String.fromEnvironment('web_contact_instagram'),
        contactWhatsApp: const String.fromEnvironment('web_contact_whatsapp'),
      ),
      permanent: true,
    );

    AppBinding.put<LocalStorage>(
      SharedPreferencesLocalStorageImpl(),
      permanent: true,
    );

    AppBinding.create<OfflineFirstLocalDatabase<Map<String, dynamic>>>(
      () => HiveOfflineFirstLocalDatabase<Map<String, dynamic>>(),
    );

    AppBinding.put<HttpClient>(
      HttpClientImpl(
        serverEnv: AppBinding.find(),
        interceptors: [LogInterceptor()],
      ),
      permanent: true,
    );

    AppBinding.put<RefreshTokenDataSource>(
      RefreshTokenDataSourceImpl(),
      permanent: true,
    );

    AppBinding.put<LoginDataSource>(
      LoginDataSourceImpl(
        http: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.put<LogoutDataSource>(
      LogoutDataSourceImpl(
        http: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.lazyPut<IpAddressLocationDataSource>(
      () => IpAddressLocationDataSourceImpl(
        http: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<AppInstallationDataSource>(
      () => AppInstallationDataSourceImpl(
        http: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<UserDataSource>(
      () => UserDataSourceImpl(
        http: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<NotificationDataSource>(
      () => NotificationDataSourceImpl(
        http: AppBinding.find(),
      ),
    );
  }
}
