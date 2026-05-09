import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/presentation.dart';

class DeleteAccountConfirmationController extends BaseController {
  final DeleteUserUseCase _deleteUserUseCase;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final DeleteAccountStore _deleteAccountStore;
  final AppSecurityManager _appSecurityManager;
  final UserEntity _userEntity;

  DeleteAccountConfirmationController({
    required DeleteUserUseCase deleteUserUseCase,
    required UserAuthStorageUseCase userAuthStorageUseCase,
    required DeleteAccountStore deleteAccountStore,
    required AppSecurityManager appSecurityManager,
    required UserEntity userEntity,
  }) : _deleteUserUseCase = deleteUserUseCase,
       _userAuthStorageUseCase = userAuthStorageUseCase,
       _deleteAccountStore = deleteAccountStore,
       _appSecurityManager = appSecurityManager,
       _userEntity = userEntity;

  UserEntity get user => _userEntity;

  final RxBool _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;

  @override
  void onClose() {
    _isLoading.close();
    super.onClose();
  }

  Future<void> deleteAccount() async {
    _isLoading.value = true;
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
      _isLoading.value = false;
    }
  }

  void closeDeleteAccount() {
    AppNavigator.backUntil(AppRouter.settings);
  }
}
