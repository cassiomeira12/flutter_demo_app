import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';

class CredentialController extends BaseController with UrlValidator {
  final CreateCredentialUseCase _createCredentialUseCase;
  final UpdateCredentialUseCase _updateCredentialUseCase;
  final DeleteCredentialUseCase _deleteCredentialUseCase;
  final CredentialsStore _credentialsStore;
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final ClipboardUseCase _clipboardUseCase;

  CredentialController({
    required CreateCredentialUseCase createCredentialUseCase,
    required UpdateCredentialUseCase updateCredentialUseCase,
    required DeleteCredentialUseCase deleteCredentialUseCase,
    required CredentialsStore credentialsStore,
    required OpenWebUrlUseCase openWebUrlUseCase,
    required ClipboardUseCase clipboardUseCase,
  }) : _createCredentialUseCase = createCredentialUseCase,
       _updateCredentialUseCase = updateCredentialUseCase,
       _deleteCredentialUseCase = deleteCredentialUseCase,
       _credentialsStore = credentialsStore,
       _openWebUrlUseCase = openWebUrlUseCase,
       _clipboardUseCase = clipboardUseCase;

  final credentialNameTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final secretKeyOTPTextController = TextEditingController();
  final urlTextController = TextEditingController();
  final notesTextController = TextEditingController();

  CredentialEntity? get _credentialSelected =>
      _credentialsStore.credential.value;
  bool get hasCredential => _credentialSelected != null;

  RxBool showOtpWidget = RxBool(false);
  RxBool showOpenUrl = RxBool(false);
  RxString favIconUrl = RxString('');
  String? get updatedAt {
    if (hasCredential && _credentialSelected?.updatedAt != null) {
      return DateHelper.formatDateWithTime(_credentialSelected!.updatedAt!);
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _setCredentialData(_credentialsStore.credential.value);
  }

  @override
  void onClose() {
    showOtpWidget.close();
    showOpenUrl.close();
    favIconUrl.close();
    secretKeyOTPTextController.removeListener(_changeOTPText);
    super.onClose();
  }

  void _setCredentialData(CredentialEntity? credential) {
    if (credential != null) {
      credentialNameTextController.value = TextEditingValue(
        text: credential.name,
      );
      userNameTextController.value = TextEditingValue(
        text: credential.userName ?? '',
      );
      passwordTextController.value = TextEditingValue(
        text: credential.password ?? '',
      );
      changeSecretKeyOTP(credential.secretKeyOTP);
      secretKeyOTPTextController.value = TextEditingValue(
        text: credential.secretKeyOTP ?? '',
      );
      secretKeyOTPTextController.addListener(_changeOTPText);
      urlValidation(credential.url);
      urlTextController.value = TextEditingValue(
        text: credential.url ?? '',
      );
      notesTextController.value = TextEditingValue(
        text: credential.notes ?? '',
      );
    }
  }

  void _changeOTPText() => changeSecretKeyOTP(secretKeyOTPTextController.text);

  Future<void> saveCredential({
    required String credentialName,
    required String userName,
    required String password,
    required String secretKeyOTP,
    required String url,
    required String notes,
  }) async {
    clickTagging(component: 'save_credential_button_key');

    final tempCredential = CredentialEntity(
      objectId: _credentialsStore.credential.value?.objectId ?? '',
      name: credentialName,
      userName: userName.isEmpty ? null : userName,
      password: password.isEmpty ? null : password,
      secretKeyOTP: secretKeyOTP.isEmpty ? null : secretKeyOTP,
      url: url.isEmpty ? null : url,
      faviconUrl: favIconUrl.value,
      notes: notes.isEmpty ? null : notes,
      createdAt: _credentialsStore.credential.value?.createdAt,
      updatedAt: _credentialsStore.credential.value?.updatedAt,
    );

    final CredentialEntity credential = hasCredential
        ? await _updateCredentialUseCase.call(tempCredential)
        : await _createCredentialUseCase.call(tempCredential);

    final int scrollToIndex = _credentialsStore.indexOf(credential.objectId);

    backPage(result: scrollToIndex);
  }

  Future<void> removerCredential() async {
    try {
      final credential = _credentialsStore.credential.value!;
      await _deleteCredentialUseCase.call(credential);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    } finally {
      backPage();
    }
  }

  String? nameValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'credential_name_input_error'.tr;
    }
    return null;
  }

  String? passwordValidator(String? input) {
    if (input?.isNotEmpty ?? false) {
      final int passwordUsed = _passwordUsedManyTimes(input!);
      if (passwordUsed > 0) {
        final String times = passwordUsed == 1
            ? 'your_password_was_used_one_time'.tr
            : 'your_password_was_used_many_times'.tr;
        return '${'your_password_was_used'.tr} $passwordUsed $times';
      }
    }
    return null;
  }

  String? secretOtpValidator(String? input) {
    if (input?.isNotEmpty ?? false) {
      try {
        OTP.generateTOTPCodeString(
          input!,
          DateTime.now().millisecondsSinceEpoch,
          isGoogle: true,
          algorithm: Algorithm.SHA1,
        );
        return null;
      } catch (error) {
        return 'secret_otp_invalid'.tr;
      }
    }
    return null;
  }

  String? urlValidation(String? input) {
    if (input?.trim().isEmpty ?? true) {
      showOpenUrl.value = false;
      return null;
    }
    final String? error = urlValidator(input);
    showOpenUrl.value = error?.trim().isEmpty ?? true;
    if (error == null && (input?.isNotEmpty ?? false)) {
      favIconUrl.value =
          _credentialSelected?.faviconUrl ??
          '${Uri.parse(input!).origin}/favicon.ico';
    }
    return error;
  }

  Future<void> copyText(String text, {bool autoClear = false}) async {
    await _clipboardUseCase.copy(text, autoClear: autoClear);
  }

  int _passwordUsedManyTimes(String password) {
    return _credentialsStore.credentials.fold(0, (value, credential) {
      if (credential.value.password == password) {
        if (_credentialSelected?.objectId == credential.value.objectId) {
          return value;
        }
        return value + 1;
      }
      return value;
    });
  }

  void changeSecretKeyOTP(String? input) {
    if (input?.trim().isEmpty ?? true) {
      showOtpWidget.value = false;
      return;
    }
    final String? validator = secretOtpValidator(input);
    if (validator == null) {
      showOtpWidget.value = false;
      showOtpWidget.value = true;
      return;
    }
    showOtpWidget.value = false;
  }

  void openUrl() {
    final String url = urlTextController.text.trim();
    clickTagging(component: 'open_url_link');
    _openWebUrlUseCase.call(url);
  }

  Future<void> readSecretOTPQrCode() async {
    clickTagging(component: 'read_secret_otp_qrcode');
    final String? result = await AppNavigator.toNamed(AppRouter.cameraScanner);
    if (result?.contains('otpauth://totp') ?? false) {
      final String url = Uri.decodeComponent(result!);
      final Uri uri = Uri.parse(url);

      final String secret = uri.queryParameters['secret'] ?? '';

      secretKeyOTPTextController.text = secret;
      changeSecretKeyOTP(secret);

      String? issuer;

      try {
        issuer = uri.queryParameters['issuer'];
        if (issuer?.isNotEmpty ?? false) {
          credentialNameTextController.text = issuer!;
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace, msg: 'Error decode issuer url: $url');
      }

      try {
        if (issuer == null) return;
        final String username = uri.path.substring('/$issuer:'.length);
        if (username.isNotEmpty) {
          userNameTextController.text = username;
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace, msg: 'Error decode issuer url: $url');
      }
    }
  }

  Future<void> errorFavIcon(String url, Object? error) async {
    try {
      if (!hasCredential) return;

      CredentialEntity tempCredential = CredentialEntity(
        objectId: _credentialSelected!.objectId,
        name: _credentialSelected!.name,
        userName: _credentialSelected!.userName,
        password: _credentialSelected!.password,
        secretKeyOTP: _credentialSelected!.secretKeyOTP,
        url: _credentialSelected!.url,
        faviconUrl: null,
        notes: _credentialSelected!.notes,
        createdAt: _credentialSelected!.createdAt,
        updatedAt: _credentialSelected!.updatedAt,
      );

      tempCredential = await _updateCredentialUseCase.call(tempCredential);

      _credentialsStore.credential.value = tempCredential;
      _setCredentialData(tempCredential);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }
}
