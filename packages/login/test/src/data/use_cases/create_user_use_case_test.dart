import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/infra/infra.dart';

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

    AppBinding.put<SignupDataSource>(
      SignupDataSourceImpl(http: AppBinding.find()),
    );
    AppBinding.put<SignupService>(
      SignupServiceImpl(signUpDataSource: AppBinding.find()),
    );
    AppBinding.put<CreateUserUseCase>(
      CreateUserUseCaseImpl(
        singUpService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
      ),
    );
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('should test signup already created', () async {
    final usecase = AppBinding.find<CreateUserUseCase>();

    const email = 'teste@email.com';
    final password = faker.internet.password(length: 6);

    try {
      await usecase.call(
        name: faker.person.name(),
        email: email,
        username: email,
        password: password,
      );
    } catch (error) {
      expect(error, isA<BaseException>());
      if (error is BaseException) {
        expect(error.message, 'account_already_exists_error');
      }
    }
  });

  /* group('should test signup success', () {
    test('should signup success', () async {
      final usecase = AppBinding.find<CreateUserUseCase>();

      final email = faker.internet.email();
      final password = faker.internet.password(length: 6);

      final result = await usecase.call(
        name: faker.person.name(),
        email: email,
        username: email,
        password: password,
      );

      expect(result, isA<UserEntity>());
      expect(result.sessionToken, isNotNull);

      expect(AppBinding.find<SessionEntity>().token, result.sessionToken);
      expect(AppBinding.hasInstance<UserEntity>(), true);
    });

    tearDownAll(() async {
      expect(AppBinding.hasInstance<SessionEntity>(), true);
      expect(AppBinding.find<SessionEntity>().isAuthenticated, true);
      expect(AppBinding.find<SessionEntity>().token, isNotNull);

      final String deleteAccountReason = faker.lorem.sentence();
      final userService = AppBinding.find<UserService>();
      await userService.deleteUser(deleteAccountReason);

      await AppBinding.replace<SessionEntity>(SessionEntity());
      await AppBinding.delete<UserEntity>(force: true);

      expect(AppBinding.find<SessionEntity>().isAuthenticated, false);
      expect(AppBinding.find<SessionEntity>().token, isNull);
      expect(AppBinding.hasInstance<UserEntity>(), false);
    });
  }); */
}
