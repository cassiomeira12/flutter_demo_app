import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'user.dart';

class UserPage extends AppView<UserController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'my_data'.tr,
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
                      child: FlutterIcon(
                        BoxIcons.bx_user,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
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
                      child: FlutterIcon(
                        BoxIcons.bx_mail_send,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  // const SpacerWidget(),
                  // TextFieldWidget(
                  //   key: const Key('phone_number_input_key'),
                  //   label: 'Telefone',
                  //   hintText: 'Seu telefone',
                  //   enabled: false,
                  //   controller: TextEditingController(
                  //     text: controller.user.phoneNumber,
                  //   ),
                  //   keyboardType: TextInputType.phone,
                  //   prefixIcon: SizedBox(
                  //     width: ResponsiveSizeHelper.width(35),
                  //     child: FlutterIcon(
                  //       BoxIcons.bxl_whatsapp,
                  //     ),
                  //   ),
                  // ),
                  const SpacerWidget(height: 2),
                  SecondaryButton(
                    key: const Key('change_password_button_key'),
                    text: 'change_password'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(BoxIcons.bx_key),
                    onPressed: controller.changePassword,
                  ),
                  const SpacerWidget(height: 2),
                  PrimaryButton(
                    key: const Key('delete_account_button_key'),
                    text: 'delete_my_account'.tr,
                    expandWidth: true,
                    backgroundColor: AppColors.statusError,
                    onPressed: controller.deleteAccount,
                  ),
                  const SpacerWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
