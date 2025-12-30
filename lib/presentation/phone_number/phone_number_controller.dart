import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class PhoneNumberController extends BaseController {
  final SendWhatsAppCodeUseCase _sendWhatsAppCodeUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final LogoutUseCase _logoutUseCase;

  PhoneNumberController({
    required SendWhatsAppCodeUseCase sendWhatsAppCodeUseCase,
    required UpdateUserDataUseCase updateUserDataUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _sendWhatsAppCodeUseCase = sendWhatsAppCodeUseCase,
       _updateUserDataUseCase = updateUserDataUseCase,
       _logoutUseCase = logoutUseCase;

  final phoneControler = MaskedTextController(mask: '(00) 0 0000-0000');

  String phoneNumber = '';
  String code = '';

  RxBool typeCode = false.obs;
  UserEntity user = AppBinding.find();
  String _code = '';

  @override
  void onInit() {
    phoneNumber = user.phoneNumberWithoutCountry;
    phoneControler.value = TextEditingValue(text: phoneNumber);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _code = '${DateTime.now().millisecondsSinceEpoch}';
    _code = _code.substring(_code.length - 4, _code.length);
  }

  @override
  Future<void> backPage({
    dynamic result,
    bool ignoreId = false,
    bool? onlyPopStackRouter,
  }) async {
    try {
      _logoutUseCase.call();
    } catch (_) {
    } finally {
      await SessionHelper.clear();
      super.backPage(result: result);
    }
  }

  Future<void> sendWhatsAppCode({
    required String phoneNumber,
  }) async {
    try {
      await _sendWhatsAppCodeUseCase.call(
        phoneNumber: phoneNumber,
        code: _code,
      );

      typeCode.value = true;
    } catch (error) {
      final UserEntity userUpdate = user.copyWith(
        phoneNumber: phoneNumber,
        phoneVerified: false,
      );

      await _updateUserDataUseCase.call(userUpdate);

      // AppNavigator.offNamedUntil(AppRouter.home, stopRoute: AppRouter.splash);
    }
  }

  Future<void> savePhoneNumber({
    required String phoneNumber,
    required String code,
  }) async {
    if (_code.compareTo(code) == 0) {
      final UserEntity userUpdate = user.copyWith(
        phoneNumber: phoneNumber,
        phoneVerified: true,
      );

      await _updateUserDataUseCase.call(userUpdate);

      // AppNavigator.offNamedUntil(AppRouter.home, stopRoute: AppRouter.splash);
    } else {
      throw BaseException(message: 'invalid_code');
    }
  }

  String? phoneNumberValidator(String? input) {
    if (input!.isEmpty) {
      return 'write_whatsapp_number'.tr;
    } else if (input.length < 16) {
      return 'write_whatsapp_correct_number'.tr;
    }
    return null;
  }

  String? codeValidator(String? input) {
    if (input != _code) {
      return 'invalid_code'.tr;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      _logoutUseCase.call();
    } catch (_) {
    } finally {
      await SessionHelper.clear();
      AppNavigator.backAllAndToNamed(AppRouter.splash);
    }
  }

  void verifiedPhoneNumberLater() {
    // AppNavigator.offNamedUntil(AppRouter.home, stopRoute: AppRouter.splash);
  }
}
