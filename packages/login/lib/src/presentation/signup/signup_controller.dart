import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:login/src/domain/domain.dart';

class SignUpController extends BaseController
    with
        NameValidator,
        EmailValidator,
        PasswordValidator,
        ConfirmPasswordValidator {
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  SignUpController({
    required this._createUserUseCase,
    required this._updateUserLocaleUseCase,
    required this._uploadInstallationAppUseCase,
    required this._openWebUrlUseCase,
  });

  final privacyAndTerms = ValueNotifier<bool>(false);

  @override
  void onClose() {
    privacyAndTerms.dispose();
    super.onClose();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    clickTagging(component: 'signup_button_key');

    final user = await _createUserUseCase.call(
      name: name,
      email: email,
      username: email,
      password: password,
    );

    _updateUserData(user);
    _updateUserInstallation();

    signupTagging();
    setUserIdentifier(user.id, property: user.toMap());

    AppNavigator.backAndToNamed(AppRouter.home);
  }

  Future<void> _updateUserData(UserEntity user) async {
    try {
      await _updateUserLocaleUseCase.call(user);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  Future<void> _updateUserInstallation() async {
    try {
      await _uploadInstallationAppUseCase.call();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  void termsConditions() {
    clickTagging(component: 'terms_conditions_hyperlink_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/terms-conditions';
    _openWebUrlUseCase.call(url);
  }

  void privacyPolicy() {
    clickTagging(component: 'privacy_policy_hyperlink_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/privacy-policy';
    _openWebUrlUseCase.call(url);
  }
}
