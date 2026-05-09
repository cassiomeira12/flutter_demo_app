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

  group('test login and logout', () {
    test('should login success', () async {
      final service = AppBinding.find<LoginService>();

      final result = await service.login(
        username: 'teste@email.com',
        password: '123456',
      );

      AppBinding.replace<SessionEntity>(
        SessionEntity(token: result.sessionToken),
      );

      expect(result, isNotNull);
    });

    test('should logout success', () async {
      final service = AppBinding.find<LogoutService>();

      await service.logout();

      await AppBinding.replace<SessionEntity>(SessionEntity());
      await AppBinding.delete<UserEntity>(force: true);

      expect(AppBinding.find<SessionEntity>().isAuthenticated, false);
      expect(AppBinding.find<SessionEntity>().token, isNull);
      expect(AppBinding.hasInstance<UserEntity>(), false);
    });
  });
}
