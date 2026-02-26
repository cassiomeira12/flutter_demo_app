import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/change_password/change_password.dart';

class ChangePasswordPage extends AppView<ChangePasswordController> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'change_password'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SpacerWidget(),
                    TextFieldWidget(
                      key: const Key('password_input_key'),
                      label: 'password_label'.tr,
                      hintText: 'current_password'.tr,
                      controller: currentPasswordController,
                      validator: controller.passwordValidator,
                      obscureText: true,
                    ),
                    const SpacerWidget(),
                    TextFieldWidget(
                      key: const Key('new_password_input_key'),
                      label: 'new_password'.tr,
                      hintText: 'create_strong_password'.tr,
                      controller: newPasswordController,
                      validator: (input) {
                        return controller.newPasswordValidator(
                          input,
                          currentPassword: currentPasswordController.text
                              .trim(),
                        );
                      },
                      obscureText: true,
                    ),
                    const SpacerWidget(),
                    TextFieldWidget(
                      key: const Key('confirm_password_input_key'),
                      label: 'repeat_password'.tr,
                      hintText: 'repeat_password_hint'.tr,
                      validator: (input) {
                        return controller.confirmPasswordValidator(
                          input,
                          password: newPasswordController.text.trim(),
                        );
                      },
                      obscureText: true,
                    ),
                    const SpacerWidget(height: 3),
                    FutureButton(
                      key: const Key('change_password_button_key'),
                      text: 'save'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final currentPassword = currentPasswordController
                              .value
                              .text
                              .trim();
                          final newPassword = newPasswordController.value.text
                              .trim();

                          try {
                            await controller.changePassword(
                              currentPassword: currentPassword,
                              newPassword: newPassword,
                            );

                            if (!context.mounted) return;

                            DialogWidget.show(
                              context,
                              title: 'change_password_success_title'.tr,
                              message: 'change_password_success_message'.tr,
                            ).whenComplete(() {
                              if (context.mounted) {
                                controller.backPage();
                              }
                            });
                          } on BaseException catch (error) {
                            if (!context.mounted) return;
                            DialogWidget.showError(
                              context,
                              message: error.message.tr,
                            );
                          }
                        }
                      },
                    ),
                    const SpacerWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
