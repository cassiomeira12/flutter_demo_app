import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:login/src/presentation/recovery_password/recovery_password.dart';

class RecoveryPasswordPage extends AppView<RecoveryPasswordController> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();

  RecoveryPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'recovery_password'.tr,
      controller: controller,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
          child: Column(
            children: [
              const SpacerWidget(height: 2),
              TextWidget('recovery_password_message'.tr),
              const SpacerWidget(height: 2),
              Form(
                key: _formKey,
                child: TextFieldWidget(
                  key: const Key('username_input_key'),
                  label: 'username_label'.tr,
                  hintText: 'username_input_hint'.tr,
                  controller: _emailTextController,
                  validator: controller.emailValidator,
                ),
              ),
              const SpacerWidget(height: 2),
              FutureButton(
                key: const Key('recovery_password_button_key'),
                text: 'recovery_password_button'.tr,
                expandWidth: true,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    FocusManager.instance.primaryFocus?.unfocus();

                    final email = _emailTextController.text.trim();

                    try {
                      await controller.recoveryPassword(email: email);

                      if (!context.mounted) return;

                      DialogWidget.show(
                        context,
                        title: 'recovery_password_success_title'.tr,
                        message: 'recovery_password_success_message'.tr,
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
              const SpacerWidget(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
