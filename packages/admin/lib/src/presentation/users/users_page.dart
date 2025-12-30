import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'users.dart';
import 'widgets/user_widget.dart';

class UsersPage extends AppView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'users'.tr,
      controller: controller,
      body: ScrollStateWidget<UserEntity>(
        list: controller.users,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.getAllUsers,
        emptyMessage: 'empty_users_list'.tr,
        builder: (context, index, item) {
          return UserWidget(
            user: item,
            popMenuItems: const ['send_push'],
            onPopMenuTap: (menu) {
              controller.onPopMenuSelected(item, menu);
            },
            onTap: () {
              controller.openUserDetails(item);
            },
          );
        },
      ),
    );
  }
}
