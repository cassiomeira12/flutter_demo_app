import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LoginController extends BaseController
    with EmailValidator, PasswordValidator {
  final EnvironmentEntity _environment;
  final LoginUseCase _loginUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final AppInfoEntity _appInfoEntity;

  LoginController({
    required EnvironmentEntity environment,
    required LoginUseCase loginUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UserAuthStorageUseCase authStorageUseCase,
    required UpdateUserLocaleUseCase updateUserLocaleUseCase,
    required UploadInstallationAppUseCase uploadInstallationAppUseCase,
    required AppInfoEntity appInfoEntity,
  }) : _environment = environment,
       _loginUseCase = loginUseCase,
       _localStorageUseCase = localStorageUseCase,
       _authStorageUseCase = authStorageUseCase,
       _updateUserLocaleUseCase = updateUserLocaleUseCase,
       _uploadInstallationAppUseCase = uploadInstallationAppUseCase,
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

  @override
  void onReadyPage(BuildContext context) {
    super.onReadyPage(context);
    _showInvalidSessionAlert(context);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'login',
      operation: 'user-login',
    );
    try {
      clickTagging(component: 'login_button_key');

      final user = await _loginUseCase.call(
        username: username,
        password: password,
      );

      _updateUserData(user);
      _updateUserInstallation();

      loginTagging();
      setUserIdentifier(user.id, property: user.toMap());

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
      track.catchError(error: error);
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
      await SessionHelper.clear();
      rethrow;
    } finally {
      track.finish();
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

  Future<void> _updateUserData(UserEntity user) async {
    try {
      await _updateUserLocaleUseCase.call(user);
    } catch (error, stackTrace) {
      Log.error(
        'Login error updateUser',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _updateUserInstallation() async {
    try {
      await _uploadInstallationAppUseCase.call();
    } catch (error, stackTrace) {
      Log.error(
        'Login error uploadInstallation',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _getLoginEmailSaved() async {
    final bool? rememberMe = await _localStorageUseCase.get<bool>(REMEMBER_ME);
    final Map<String, String?> credentials = await _authStorageUseCase
        .getCredentials();
    final String? username = credentials['username'];
    final String? password = credentials['password'];

    rememberMeInitial.value = rememberMe ?? false;
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

  Future<void> _showInvalidSessionAlert(BuildContext context) async {
    final sessionExpired = await _localStorageUseCase.get<bool>(
      SESSION_WAS_EXPIRED,
    );
    if (sessionExpired == true) {
      if (!context.mounted) return;
      _localStorageUseCase.delete(SESSION_WAS_EXPIRED);
      SnackBarWidget.show(
        context,
        title: 'invalid_session_token'.tr,
        message: 'login_again'.tr,
      );
    }
  }
}
