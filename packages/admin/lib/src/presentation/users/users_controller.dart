import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/presentation/users/users.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UsersController extends BaseController {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final UsersStore _usersStore;

  UsersController({
    required this._getAllUsersUseCase,
    required this._usersStore,
  });

  RxList<UserEntity> users = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  @override
  String get pageRouteNamed => AppRouter.users.name;

  @override
  void onReady() {
    super.onReady();
    getAllUsers();
  }

  @override
  void onClose() {
    users.close();
    isLoading.close();
    errorMessage.close();
    super.onClose();
  }

  Future<void> getAllUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      users.value = await _getAllUsersUseCase.call(0);
    } on BaseException catch (error) {
      errorMessage.value = error.message.tr;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void openUserDetails(UserEntity user) {
    _usersStore.userSelected = user;
    AppNavigator.toNamed(AppRouter.usersDetails);
  }

  void onPopMenuSelected(UserEntity user, String menu) {
    switch (menu) {
      case 'send_push':
        _usersStore.userSelected = user;
        AppNavigator.toNamed(AppRouter.pushNotifications);
      default:
    }
  }
}
