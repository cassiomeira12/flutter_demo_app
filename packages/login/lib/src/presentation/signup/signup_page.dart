import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:login/src/presentation/signup/signup.dart';

class SignUpPage extends AppView<SignUpController> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'signup'.tr,
      controller: controller,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFieldWidget(
                  key: const Key('name_input_key'),
                  label: 'name'.tr,
                  hintText: 'enter_your_full_name'.tr,
                  controller: _nameTextController,
                  validator: controller.nameValidator,
                  keyboardType: TextInputType.name,
                ),
                const SpacerWidget(height: 2),
                TextFieldWidget(
                  key: const Key('email_input_key'),
                  label: 'username_label'.tr,
                  hintText: 'username_input_hint'.tr,
                  controller: _emailTextController,
                  validator: controller.emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SpacerWidget(height: 2),
                TextFieldWidget(
                  key: const Key('password_input_key'),
                  label: 'password_label'.tr,
                  hintText: 'create_strong_password'.tr,
                  controller: _passwordTextController,
                  validator: controller.passwordValidator,
                  obscureText: true,
                ),
                const SpacerWidget(height: 2),
                TextFieldWidget(
                  key: const Key('confirm_password_input_key'),
                  label: 'repeat_password'.tr,
                  hintText: 'repeat_password_hint'.tr,
                  validator: (value) {
                    return controller.confirmPasswordValidator(
                      value,
                      password: _passwordTextController.text,
                    );
                  },
                  obscureText: true,
                ),
                const SpacerWidget(height: 3),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: ResponsiveSizeHelper.maxWidth,
                  ),
                  child: Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: controller.privacyAndTerms,
                        builder: (context, value, child) {
                          return CheckboxWidget(
                            key: const Key(
                              'accept_terms_and_policy_checkbox_widget_key',
                            ),
                            value: value,
                            onChanged: (newValue) {
                              controller.privacyAndTerms.value = newValue;
                            },
                          );
                        },
                      ),
                      const SpacerWidget(),
                      Flexible(
                        child: TextRichWidget(
                          children: [
                            TextRichWidget(
                              text: 'accept_terms_conditions'.tr,
                            ),
                            TextRichWidget(
                              key: const Key(
                                'terms_conditions_hyperlink_key',
                              ),
                              text: 'terms_conditions'.tr.toLowerCase(),
                              style: AppTextStyle.hyperlink(context),
                              onTap: controller.termsConditions,
                            ),
                            TextRichWidget(
                              text: 'accept_terms_conditions_and'.tr,
                            ),
                            TextRichWidget(
                              key: const Key('privacy_policy_hyperlink_key'),
                              text: 'privacy_policy'.tr.toLowerCase(),
                              style: AppTextStyle.hyperlink(context),
                              onTap: controller.privacyPolicy,
                            ),
                            const TextRichWidget(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(height: 3),
                FutureButton(
                  key: const Key('signup_button_key'),
                  text: 'signup'.tr,
                  expandWidth: true,
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (!controller.privacyAndTerms.value) {
                        DialogWidget.show(
                          context,
                          title: '',
                          message:
                              'must_accept_terms_conditions_and_privacy_policy'
                                  .tr,
                        );
                        return;
                      }

                      if (kReleaseMode) {
                        final captchaAccepted = await Captcha.show(context);
                        if (captchaAccepted != true) {
                          return;
                        }
                      }

                      final name = _nameTextController.value.text.trim();
                      final email = _emailTextController.value.text.trim();
                      final password = _passwordTextController.value.text
                          .trim();

                      try {
                        await controller.signUp(
                          name: name,
                          email: email,
                          password: password,
                        );
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
      ),
    );
  }
}
