import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PushNotificationsController extends BaseController {
  // final GetAllUsersUseCase _getAllUsersUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final TestPushNotificationUseCase _testPushNotificationUseCase;

  PushNotificationsController({
    // required GetAllUsersUseCase getAllUsersUseCase,
    required CreateNotificationUseCase createNotificationUseCase,
    required TestPushNotificationUseCase testPushNotificationUseCase,
  }) : // _getAllUsersUseCase = getAllUsersUseCase,
       _createNotificationUseCase = createNotificationUseCase,
       _testPushNotificationUseCase = testPushNotificationUseCase;

  @override
  String get pageRouteNamed => AppRouter.pushNotifications.name;

  UserEntity user = AppBinding.find();
  // UsersStore usersStore = AppBinding.find();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final imageController = TextEditingController();
  final userController = TextEditingController();

  // UserEntity? get userSelected => usersStore.userSelected;

  @override
  void onInit() {
    super.onInit();
    // userController.value = TextEditingValue(
    //   text: usersStore.userSelected?.username ?? '',
    // );
  }

  Future<List<UserEntity>> searchUsers(
    String? query,
    int? take,
    int? skip,
  ) async {
    return [];
    // return await _getAllUsersUseCase.call(0);
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

  Future<void> testPush({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    await _testPushNotificationUseCase.call(
      title: title,
      body: body,
      imageUrl: imageUrl,
    );
  }
}
