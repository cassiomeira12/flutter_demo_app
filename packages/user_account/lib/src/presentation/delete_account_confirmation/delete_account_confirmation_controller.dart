import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/presentation.dart';

class DeleteAccountConfirmationController extends BaseController {
  final DeleteUserUseCase _deleteUserUseCase;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final DeleteAccountStore _deleteAccountStore;
  final AppSecurityManager _appSecurityManager;

  DeleteAccountConfirmationController({
    required DeleteUserUseCase deleteUserUseCase,
    required UserAuthStorageUseCase userAuthStorageUseCase,
    required DeleteAccountStore deleteAccountStore,
    required AppSecurityManager appSecurityManager,
  }) : _deleteUserUseCase = deleteUserUseCase,
       _userAuthStorageUseCase = userAuthStorageUseCase,
       _deleteAccountStore = deleteAccountStore,
       _appSecurityManager = appSecurityManager;

  UserEntity user = AppBinding.find();

  Future<void> deleteAccount() async {
    clickTagging(component: 'settings_logout_key');
    if (kReleaseMode) {
      final String reason = _deleteAccountStore.selectedReason.value!;
      await _deleteUserUseCase.call(reason);
    }
    await _userAuthStorageUseCase.clearCredentials();
    await _appSecurityManager.clearSettings();
    await _appSecurityManager.init();
    await SessionHelper.clear();
    AppNavigator.toNamed(AppRouter.deleteAccountFinished);
  }

  void closeDeleteAccount() {
    AppNavigator.backUntil(AppRouter.settings);
  }
}
