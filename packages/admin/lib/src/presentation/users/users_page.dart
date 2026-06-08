import 'package:admin/src/presentation/users/users.dart';
import 'package:admin/src/presentation/users/widgets/user_widget.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class UsersPage extends AppView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'users'.tr,
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          key: const Key('users_history_update_popup_menu_item_key'),
          value: 'update'.tr,
          onTap: controller.getAllUsers,
          child: TextWidget('update'.tr),
        ),
      ],
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
