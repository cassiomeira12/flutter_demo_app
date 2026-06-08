import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/presentation/signup/signup.dart';

class UpdateUserLocaleUseCaseMock extends Mock
    implements UpdateUserLocaleUseCase {
  @override
  Future<void> call(UserEntity user, {Locale? definedLocale}) async {}
}

class UploadInstallationAppUseCaseMock extends Mock
    implements UploadInstallationAppUseCase {
  @override
  Future<InstallationEntity> call() async {
    return InstallationEntity(
      installationId: '',
      appName: '',
      appVersion: '',
      appIdentifier: '',
      channels: [],
      gcmSenderId: '',
      deviceToken: '',
      pushType: '',
      deviceId: '',
      deviceBrand: '',
      deviceModel: '',
      deviceType: '',
      deviceOsVersion: '',
      timeZone: '',
      localeIdentifier: '',
      platform: '',
      ip: '',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  MaterialApp? app;
  ThemeManager.instance.defineColor();

  setUpAll(() async {
    registerFallbackValue(UpdateUserLocaleUseCaseMock());
    registerFallbackValue(UploadInstallationAppUseCaseMock());

    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();

    AppBinding.put<UpdateUserLocaleUseCase>(UpdateUserLocaleUseCaseMock());
    AppBinding.put<UploadInstallationAppUseCase>(
      UploadInstallationAppUseCaseMock(),
    );

    await DomainModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  setUp(() {
    SignUpBindings().dependencies();

    app = MaterialApp(
      home: ScaffoldWidget(
        controller: null,
        body: SignUpPage(),
      ),
    );
  });

  tearDown(() {
    AppBinding.delete<SignUpController>();
    AppBinding.delete<CreateUserUseCase>();
    AppBinding.delete<SignupService>();
    AppBinding.delete<SignupDataSource>();
  });

  testWidgets('test toggle button page', (tester) async {
    await tester.pumpWidget(app!);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('name_input_key')), findsOneWidget);
    expect(find.byKey(const Key('email_input_key')), findsOneWidget);
    expect(find.byKey(const Key('password_input_key')), findsOneWidget);
    expect(find.byKey(const Key('confirm_password_input_key')), findsOneWidget);
    expect(
      find.byKey(const Key('accept_terms_and_policy_checkbox_widget_key')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('signup_button_key')), findsOneWidget);
  });
}
