import 'package:clean_code_infra/src/data_sources/data_sources.dart';
import 'package:clean_code_infra/src/http/http.dart';
import 'package:clean_code_infra/src/local_storage/local_storage.dart';
import 'package:core/core.dart';

class InfraModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<LocalStorage>(LocalStorageImpl(), permanent: true);

    AppBinding.put<HttpClient>(
      HttpClientImpl(
        baseUrl: const String.fromEnvironment('server_url'),
        interceptors: [],
      ),
      permanent: true,
    );

    AppBinding.put<RefreshTokenDataSource>(
      RefreshTokenDataSourceImpl(),
      permanent: true,
    );

    AppBinding.put<LoginDataSource>(
      LoginDataSourceImpl(http: AppBinding.find()),
      permanent: true,
    );

    AppBinding.put<LogoutDataSource>(
      LogoutDataSourceImpl(http: AppBinding.find()),
      permanent: true,
    );

    AppBinding.lazyPut<IpAddressLocationDataSource>(
      () => IpAddressLocationDataSourceImpl(http: AppBinding.find()),
    );

    AppBinding.lazyPut<AppInstallationDataSource>(
      () => AppInstallationDataSourceImpl(http: AppBinding.find()),
    );

    AppBinding.lazyPut<UserDataSource>(
      () => UserDataSourceImpl(http: AppBinding.find()),
    );

    AppBinding.lazyPut<NotificationDataSource>(
      () => NotificationDataSourceImpl(http: AppBinding.find()),
    );

    AppBinding.lazyPut<WebVisitHistoryDataSource>(
      () => WebVisitHistoryDataSourceImpl(http: AppBinding.find()),
    );
  }
}
