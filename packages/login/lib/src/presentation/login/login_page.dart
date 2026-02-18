import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/presentation/login/login.dart';

class LoginPage extends AppView<LoginController> {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: controller.appName,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget('login'.tr, style: AppTextStyle.title(context)),
                    const SpacerWidget(),
                    Obx(() {
                      if (controller.emailTextController.value == null) {
                        return const SizedBox.shrink();
                      }
                      return TextFieldWidget(
                        key: const Key('username_input_key'),
                        label: 'username_label'.tr,
                        hintText: 'username_input_hint'.tr,
                        controller: controller.emailTextController.value,
                        validator: controller.emailValidator,
                        keyboardType: TextInputType.emailAddress,
                      );
                    }),
                    const SpacerWidget(),
                    Obx(() {
                      if (controller.passwordTextController.value == null) {
                        return const SizedBox.shrink();
                      }
                      return TextFieldWidget(
                        key: const Key('password_input_key'),
                        label: 'password_label'.tr,
                        hintText: 'password_input_hint'.tr,
                        controller: controller.passwordTextController.value,
                        validator: controller.passwordValidator,
                        obscureText: true,
                      );
                    }),
                    const SpacerWidget(height: 2),
                    Obx(() {
                      return CheckboxTitleWidget(
                        key: const Key('remember_checkbox_key'),
                        text: 'remember_my_email'.tr,
                        initialValue: controller.rememberMeInitial.value,
                        onChanged: controller.saveRememberEmail,
                      );
                    }),
                    const SpacerWidget(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: ResponsiveSizeHelper.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: LightButton(
                              key: const Key('recovery_password_button_key'),
                              text: 'recovery_password_button'.tr,
                              onPressed: controller.recoveryPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(),
                    FutureButton(
                      key: const Key('login_button_key'),
                      text: 'login_button'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final String? email = controller
                              .emailTextController
                              .value
                              ?.text
                              .trim();
                          final String? password = controller
                              .passwordTextController
                              .value
                              ?.text
                              .trim();

                          try {
                            await controller.login(
                              username: email ?? '',
                              password: password ?? '',
                            );
                          } on BaseException catch (error) {
                            if (!context.mounted) return;
                            DialogWidget.showError(
                              context,
                              message: error.toString().tr,
                            );
                          }
                        }
                      },
                    ),
                    const SpacerWidget(height: 2),
                    SecondaryButton(
                      key: const Key('signup_button_key'),
                      text: 'create_new_account'.tr,
                      expandWidth: true,
                      onPressed: controller.signUp,
                    ),
                    const SpacerWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomWidget: Container(
        alignment: Alignment.center,
        height: ResponsiveSizeHelper.navigationBarHeight,
        child: TextWidget(
          '${'version'.tr} ${controller.appInfo.formattedName}',
          style: AppTextStyle.message(context, bold: true),
        ),
      ),
    );
  }
}
