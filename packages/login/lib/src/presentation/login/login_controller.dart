import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LoginController extends BaseController
    with EmailValidator, PasswordValidator {
  final EnvironmentEntity _environment;
  final LoginUseCase _loginUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final UploadInstallationAppUseCase _uploadInstallationUseCase;
  final PushMessagingService _pushMessagingService;
  final AppInfoEntity _appInfoEntity;

  LoginController({
    required EnvironmentEntity environment,
    required LoginUseCase loginUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UserAuthStorageUseCase authStorageUseCase,
    required UpdateUserLocaleUseCase updateUserLocaleUseCase,
    required UploadInstallationAppUseCase uploadInstallationUseCase,
    required PushMessagingService pushMessagingService,
    required AppInfoEntity appInfoEntity,
  }) : _environment = environment,
       _loginUseCase = loginUseCase,
       _localStorageUseCase = localStorageUseCase,
       _authStorageUseCase = authStorageUseCase,
       _updateUserLocaleUseCase = updateUserLocaleUseCase,
       _uploadInstallationUseCase = uploadInstallationUseCase,
       _pushMessagingService = pushMessagingService,
       _appInfoEntity = appInfoEntity;

  final emailTextController = Rxn<TextEditingController>();
  final passwordTextController = Rxn<TextEditingController>();
  final rememberMeInitial = RxBool(false);

  AppInfoEntity get appInfo => _appInfoEntity;

  String get appName => _environment.appName;

  @override
  void onInit() {
    super.onInit();
    _getLoginEmailSaved();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      clickTagging(component: 'login_button_key');

      final user = await _loginUseCase.call(
        username: username,
        password: password,
      );

      try {
        await _updateUserLocaleUseCase.call(user);
        await _uploadInstallationUseCase.call();
      } catch (error, stackTrace) {
        Log.error(
          'Login error updateUser uploadInstallation',
          error: error,
          stackTrace: stackTrace,
        );
      }

      loginTagging();
      setUserIdentifier(user.id, property: user.toMap());

      await _pushMessagingService.subscribeTopic(user.id);

      if (rememberMeInitial.value) {
        await _saveLoginEmail(username: username);
      } else {
        await _removeLoginEmailSaved();
      }

      if (user.permissions.contains(UserPermissionsEnum.ADMIN)) {
        AppNavigator.backAllAndToNamed(AppRouter.admin);
      } else {
        AppNavigator.backAllAndToNamed(AppRouter.home);
      }
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      await SessionHelper.clear();
      rethrow;
    }
  }

  void signUp() {
    clickTagging(component: 'signup_button_key');
    AppNavigator.toNamed(AppRouter.signup);
  }

  void recoveryPassword() {
    clickTagging(component: 'recovery_password_button_key');
    AppNavigator.toNamed(AppRouter.recoveryPassword);
  }

  Future<void> _getLoginEmailSaved() async {
    final bool? rememberMe = await _localStorageUseCase.get<bool>(REMEMBER_ME);
    rememberMeInitial.value = rememberMe ?? false;

    final Map<String, String?> credentials = await _authStorageUseCase
        .getCredentials();

    final String? username = credentials['username'];
    final String? password = credentials['password'];

    emailTextController.value = TextEditingController(text: username);
    passwordTextController.value = TextEditingController(text: password);
  }

  Future<void> _saveLoginEmail({
    required String username,
    String? password,
  }) async {
    await _authStorageUseCase.saveCredentials(
      username: username,
      password: password,
    );
  }

  Future<void> _removeLoginEmailSaved() async {
    await _authStorageUseCase.clearCredentials();
  }

  Future<void> saveRememberEmail(bool remember) async {
    rememberMeInitial.value = remember;
    await _localStorageUseCase.set<bool>(REMEMBER_ME, remember);
    clickTagging(component: 'remember_checkbox_key_${remember ? 'on' : 'off'}');
  }
}
