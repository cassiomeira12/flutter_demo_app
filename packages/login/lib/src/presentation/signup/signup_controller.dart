import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/domain/domain.dart';

class SignUpController extends BaseController
    with EmailValidator, PasswordValidator, ConfirmPasswordValidator {
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  SignUpController({
    required CreateUserUseCase createUserUseCase,
    required UpdateUserLocaleUseCase updateUserLocaleUseCase,
    required UploadInstallationAppUseCase uploadInstallationAppUseCase,
    required OpenWebUrlUseCase openWebUrlUseCase,
  }) : _createUserUseCase = createUserUseCase,
       _updateUserLocaleUseCase = updateUserLocaleUseCase,
       _uploadInstallationAppUseCase = uploadInstallationAppUseCase,
       _openWebUrlUseCase = openWebUrlUseCase;

  final privacyAndTerms = RxBool(false);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
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
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      await SessionHelper.clear();
      rethrow;
    }
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

  String? nameValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'name_input_empty_error'.tr;
    }
    return null;
  }

  void termsConditions() {
    clickTagging(component: 'terms_conditions_hyperlink_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/privacy-policy';
    _openWebUrlUseCase.call(url);
  }

  void privacyPolicy() {
    clickTagging(component: 'privacy_policy_hyperlink_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/terms-conditions';
    _openWebUrlUseCase.call(url);
  }
}
