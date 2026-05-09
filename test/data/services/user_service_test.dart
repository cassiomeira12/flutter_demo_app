import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    await DomainModuleBindings().injectDependencies();
    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();

    final List<Interceptor> httpInterceptors = [
      ParseServerHeadersInterceptor(serverEnv: AppBinding.find()),
      ParseServerAuthTokenInterceptor(),
      ServerOtpInterceptor(
        encryptServerPublicKeyUseCase: AppBinding.find(),
        getOtpCodeUseCase: AppBinding.find(),
        securityEnv: AppBinding.find(),
      ),
    ];

    final httpClient = AppBinding.find<HttpClient>();
    httpClient.addAllInterceptors(httpInterceptors);
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  group('test user service', () {
    setUpAll(() async {
      //
    });

    test('should test getUserData success', () async {
      //
    });

    test('should test update success', () async {
      //
    });

    test('should test changePassword success', () async {
      //
    });

    test('should test deleteUser success', () async {
      //
    });
  });
}
