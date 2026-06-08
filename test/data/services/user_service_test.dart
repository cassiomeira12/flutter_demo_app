import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();

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
