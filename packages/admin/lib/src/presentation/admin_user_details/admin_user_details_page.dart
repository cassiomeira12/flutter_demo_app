import 'package:admin/src/presentation/admin_user_details/admin_user_details.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AdminUserDetailsPage extends AppView<AdminUserDetailsController> {
  const AdminUserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'admin_user_details'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Column(
                children: [
                  const SpacerWidget(),
                  SizedBox(
                    width: ResponsiveSizeHelper.width(100),
                    height: ResponsiveSizeHelper.width(100),
                    child: ImageWidget(imageUrl: controller.user.avatarUrl),
                  ),
                  const SpacerWidget(),
                  LightButton(text: 'Alterar foto'.tr, onPressed: () {}),
                  const SpacerWidget(),
                  TextFieldWidget(
                    key: const Key('name_input_key'),
                    label: 'Nome',
                    hintText: 'Seu nome',
                    enabled: false,
                    controller: TextEditingController(
                      text: controller.user.name,
                    ),
                    keyboardType: TextInputType.name,
                    prefixIcon: SizedBox(
                      width: ResponsiveSizeHelper.width(35),
                      child: const FlutterIcon(Icons.person),
                    ),
                  ),
                  const SpacerWidget(),
                  TextFieldWidget(
                    key: const Key('email_input_key'),
                    label: 'E-mail',
                    hintText: 'Seu e-mail',
                    enabled: false,
                    controller: TextEditingController(
                      text: controller.user.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: SizedBox(
                      width: ResponsiveSizeHelper.width(35),
                      child: const FlutterIcon(Icons.email),
                    ),
                  ),
                  const SpacerWidget(height: 2),
                  /*SecondaryButton(
                    text: 'user_sessions'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(
                      BoxIcons.bx_desktop,
                    ),
                    onPressed: controller.openUserInstallations,
                  ),
                  const SpacerWidget(height: 2),
                  SecondaryButton(
                    text: 'change_password'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(
                      BoxIcons.bx_key,
                    ),
                    onPressed: controller.changePassword,
                  ),
                  const SpacerWidget(height: 2),
                  PrimaryButton(
                    text: 'delete_user_account'.tr,
                    expandWidth: true,
                    color: AppColors.statusError,
                    // icon: FlutterIcon(
                    //   BoxIcons.bx_info_circle,
                    // ),
                    onPressed: controller.deleteAccount,
                  ),
                  const SpacerWidget(),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
