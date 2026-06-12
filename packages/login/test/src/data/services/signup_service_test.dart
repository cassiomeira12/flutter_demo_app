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
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('should test signup already created', () async {
    final service = AppBinding.find<SignupService>();
    final encrypt = AppBinding.find<EncryptServerPublicKeyUseCase>();

    const email = 'teste@email.com';
    final password = faker.internet.password(length: 6);
    final encryptedPassword = await encrypt.call(password);

    try {
      await service.create({
        'name': faker.person.name(),
        'email': email,
        'username': email,
        'password': encryptedPassword,
      });
    } catch (error) {
      expect(error, isA<BaseException>());
      if (error is BaseException) {
        expect(error.message, 'account_already_exists_error');
      }
    }
  });

  group('should test signup success', () {
    test('should signup success', () async {
      final service = AppBinding.find<SignupService>();
      final encrypt = AppBinding.find<EncryptServerPublicKeyUseCase>();

      final email = faker.internet.email();
      final password = faker.internet.password(length: 6);
      final encryptedPassword = await encrypt.call(password);

      final result = await service.create({
        'name': faker.person.name(),
        'email': email,
        'username': email,
        'password': encryptedPassword,
      });

      expect(result, isA<UserEntity>());
      expect(result.sessionToken, isNotNull);

      AppBinding.put<UserEntity>(result);
      AppBinding.putReplace<SessionEntity>(
        SessionEntity(token: result.sessionToken),
      );
    });

    // test('should get user data', () async {
    //   expect(AppBinding.hasInstance<SessionEntity>(), true);
    //   expect(AppBinding.find<SessionEntity>().isAuthenticated, true);
    //   expect(AppBinding.find<SessionEntity>().token, isNotNull);

    //   expect(AppBinding.hasInstance<UserEntity>(), true);
    //   final user = AppBinding.find<UserEntity>();
    //   final userService = AppBinding.find<UserService>();
    //   final resultUpdated = await userService.getUserData();
    //   for (final entry in user.toMap().entries) {
    //     expect(resultUpdated.toMap()[entry.key], entry.value);
    //   }
    // });

    tearDown(() async {
      expect(AppBinding.hasInstance<SessionEntity>(), true);
      expect(AppBinding.find<SessionEntity>().isAuthenticated, true);
      expect(AppBinding.find<SessionEntity>().token, isNotNull);

      final String deleteAccountReason = faker.lorem.sentence();
      final userService = AppBinding.find<UserService>();
      await userService.deleteUser(deleteAccountReason);

      AppBinding.putReplace<SessionEntity>(SessionEntity());
      AppBinding.delete<UserEntity>(force: true);

      expect(AppBinding.find<SessionEntity>().isAuthenticated, false);
      expect(AppBinding.find<SessionEntity>().token, isNull);
      expect(AppBinding.hasInstance<UserEntity>(), false);
    });
  });
}
