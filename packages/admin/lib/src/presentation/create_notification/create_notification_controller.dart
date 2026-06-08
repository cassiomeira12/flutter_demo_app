import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/presentation/users/users.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CreateNotificationController extends BaseController {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final TestPushNotificationUseCase _testPushNotificationUseCase;

  CreateNotificationController({
    required this._getAllUsersUseCase,
    required this._createNotificationUseCase,
    required this._testPushNotificationUseCase,
  });

  @override
  String get pageRouteNamed => AppRouter.pushNotifications.name;

  UserEntity user = AppBinding.find();
  UsersStore usersStore = AppBinding.find();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final imageController = TextEditingController();
  final userController = TextEditingController();

  UserEntity? get userSelected => usersStore.userSelected;

  @override
  void onInit() {
    super.onInit();
    userController.value = TextEditingValue(
      text: usersStore.userSelected?.username ?? '',
    );
  }

  Future<List<UserEntity>> searchUsers(
    String? query,
    int? take,
    int? skip,
  ) async {
    return await _getAllUsersUseCase.call(0);
  }

  String? titleValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'push_title_input_empty_error'.tr;
    }
    return null;
  }

  String? bodyValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'push_title_input_empty_error'.tr;
    }
    return null;
  }

  Future<void> createNotification({
    required String title,
    required String body,
    String? imageUrl,
    required UserEntity user,
  }) async {
    await _createNotificationUseCase.call(
      title: title,
      body: body,
      imageUrl: imageUrl,
      user: user,
    );
  }

  Future<Result<void>> testPush({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    final result = await _testPushNotificationUseCase.call(
      TestPushNotificationDto(
        title: title,
        body: body,
        imageUrl: imageUrl,
      ),
    );

    if (result is Error) {
      Log.baseException(result.error);
    }

    return result;
  }
}
