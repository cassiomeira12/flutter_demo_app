import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/domain/domain.dart';

class SignUpController extends BaseController
    with EmailValidator, PasswordValidator, ConfirmPasswordValidator {
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final UploadInstallationAppUseCase _uploadInstallationUseCase;
  final PushMessagingService _pushpushMessagingService;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  SignUpController({
    required CreateUserUseCase createUserUseCase,
    required UpdateUserLocaleUseCase updateUserLocaleUseCase,
    required UploadInstallationAppUseCase uploadInstallationUseCase,
    required PushMessagingService pushMessagingService,
    required OpenWebUrlUseCase openWebUrlUseCase,
  }) : _createUserUseCase = createUserUseCase,
       _updateUserLocaleUseCase = updateUserLocaleUseCase,
       _uploadInstallationUseCase = uploadInstallationUseCase,
       _pushpushMessagingService = pushMessagingService,
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

      try {
        await _updateUserLocaleUseCase.call(user);
        await _uploadInstallationUseCase.call();
      } catch (error, stackTrace) {
        Log.error(
          'Signup error uploadInstallation',
          error: error,
          stackTrace: stackTrace,
        );
      }

      signupTagging();
      setUserIdentifier(user.id, property: user.toMap());

      await _pushpushMessagingService.subscribeTopic(user.id);

      AppNavigator.backAndToNamed(AppRouter.home);
    } catch (error) {
      await SessionHelper.clear();
      rethrow;
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
