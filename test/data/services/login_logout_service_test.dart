import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/infra/infra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();

    AppBinding.putReplace<LoginDataSource>(
      WorkPointLoginDataSource(http: AppBinding.find()),
    );

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

  group('test login and logout', () {
    test('should login success', () async {
      final service = AppBinding.find<LoginService>();

      final result = await service.login(
        username: 'teste@email.com',
        password: '123456',
      );

      expect(result, isNotNull);

      expect(result.id, '4fb0ce0b-7f3a-47ba-95e0-b9e3ae3003af');
      expect(result.sessionToken, isNotNull);
    });
  });
}
