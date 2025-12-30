import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../delete_account/delete_account.dart';

class DeleteAccountConfirmationController extends BaseController {
  final DeleteUserUseCase _deleteUserUseCase;
  final PushMessagingService _pushMessagingService;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final DeleteAccountStore _deleteAccountStore;
  final AppSecurityManager _appSecurityManager;

  DeleteAccountConfirmationController({
    required DeleteUserUseCase deleteUserUseCase,
    required PushMessagingService pushMessagingService,
    required UserAuthStorageUseCase userAuthStorageUseCase,
    required DeleteAccountStore deleteAccountStore,
    required AppSecurityManager appSecurityManager,
  }) : _deleteUserUseCase = deleteUserUseCase,
       _pushMessagingService = pushMessagingService,
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
    await _pushMessagingService.unsubscribeTopic(user.id);
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
