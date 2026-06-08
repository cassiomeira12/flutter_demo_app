import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/domain/domain.dart';
import 'package:user_account/src/presentation/presentation.dart';

class DeleteAccountConfirmationController extends BaseController {
  final DeleteUserUseCase _deleteUserUseCase;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final DeleteAccountStore _deleteAccountStore;
  final AppSecurityManager _appSecurityManager;
  final UserEntity _userEntity;

  DeleteAccountConfirmationController({
    required this._deleteUserUseCase,
    required this._userAuthStorageUseCase,
    required this._deleteAccountStore,
    required this._appSecurityManager,
    required this._userEntity,
  });

  UserEntity get user => _userEntity;

  final isLoading = ValueNotifier<bool>(false);

  @override
  void onClose() {
    isLoading.dispose();
    super.onClose();
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      clickTagging(component: 'settings_logout_key');

      final String reason = _deleteAccountStore.selectedReason.value!;
      await _deleteUserUseCase.call(reason);

      await _userAuthStorageUseCase.clearCredentials();
      await _appSecurityManager.clearSettings();
      await _appSecurityManager.init();
      await SessionHelper.clear();
      AppNavigator.toNamed(AppRouter.deleteAccountFinished);
    } on BaseException {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void closeDeleteAccount() {
    AppNavigator.backUntil(AppRouter.settings);
  }
}
