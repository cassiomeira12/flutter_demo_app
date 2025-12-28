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

  final timeToClearClipboard = const Duration(seconds: 15);

  final credentialNameTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final secretKeyOTPTextController = TextEditingController();
  final urlTextController = TextEditingController();
  final notesTextController = TextEditingController();

  UserEntity get user => AppBinding.find<UserEntity>();
  CredentialEntity? get _credentialSelected =>
      _credentialsStore.credential.value;
  bool get hasCredential => _credentialSelected != null;
  RxBool showOtpWidget = RxBool(false);
  RxBool showOpenUrl = RxBool(false);
  RxString favIconUrl = RxString('');
  String? get updatedAt {
    if (hasCredential) {
      final date = DateHelper.parse(_credentialSelected!.updatedAt);
      return DateHelper.formatDateWithTime(date);
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _setCredentialData(_credentialsStore.credential.value);
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
      secretKeyOTPTextController.addListener(() {
        changeSecretKeyOTP(secretKeyOTPTextController.text);
      });
      urlValidation(credential.url);
      urlTextController.value = TextEditingValue(
        text: credential.url ?? '',
      );
      notesTextController.value = TextEditingValue(
        text: credential.notes ?? '',
      );
    }
  }

  Future<void> saveCredential({
    required String credentialName,
    required String userName,
    required String password,
    required String secretKeyOTP,
    required String url,
    required String notes,
  }) async {
    final tempCredential = CredentialEntity(
      objectId: _credentialsStore.credential.value?.objectId ?? '',
      name: credentialName,
      userName: userName.isEmpty ? null : userName,
      password: password.isEmpty ? null : password,
      secretKeyOTP: secretKeyOTP.isEmpty ? null : secretKeyOTP,
      url: url.isEmpty ? null : url,
      faviconUrl: favIconUrl.value,
      notes: notes.isEmpty ? null : notes,
      createdAt: _credentialsStore.credential.value?.createdAt ?? '',
      updatedAt: _credentialsStore.credential.value?.updatedAt ?? '',
    );

    late String credentialsId;

    if (hasCredential) {
      final updated = await _updateCredentialUseCase.call(tempCredential);
      final int? index = _credentialsStore.selectedIndex;
      if (index != null) {
        _credentialsStore.credentials[index] = updated;
      }
      credentialsId = updated.objectId;
    } else {
      final created = await _createCredentialUseCase.call(tempCredential);
      _credentialsStore.credentials.add(created);
      credentialsId = created.objectId;
    }

    _credentialsStore.credentials.sort((a, b) => a.name.compareTo(b.name));
    final int scrollToIndex = _credentialsStore.credentials.indexWhere(
      (item) => item.objectId == credentialsId,
    );

    backPage(result: scrollToIndex);
  }

  Future<void> removerCredential() async {
    try {
      final credential = _credentialsStore.credential.value!;
      await _deleteCredentialUseCase.call(credential);

      final int? index = _credentialsStore.selectedIndex;
      if (index != null) {
        _credentialsStore.credentials.removeAt(index);
      }

      backPage();
    } catch (error) {
      //
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
      favIconUrl.value = '${Uri.parse(input!).origin}/favicon.ico';
    }
    return error;
  }

  Future<void> copyText(String text) async {
    await _clipboardUseCase.copy(text);
    Future.delayed(timeToClearClipboard, _clearClipboard);
  }

  void _clearClipboard() {
    _clipboardUseCase.copy('');
  }

  int _passwordUsedManyTimes(String password) {
    return _credentialsStore.credentials.fold(0, (value, credential) {
      if (credential.password == password) {
        if (_credentialSelected?.objectId == credential.objectId) {
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
    _openWebUrlUseCase.call(url);
  }

  Future<void> readSecretOTPQrCode() async {
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
        Log.error(
          'Error decode issuer url: $url',
          error: error,
          stackTrace: stackTrace,
        );
      }

      try {
        if (issuer == null) return;
        final String username = uri.path.substring('/$issuer:'.length);
        if (username.isNotEmpty) {
          userNameTextController.text = username;
        }
      } catch (error, stackTrace) {
        Log.error(
          'Error decode issuer url: $url',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
