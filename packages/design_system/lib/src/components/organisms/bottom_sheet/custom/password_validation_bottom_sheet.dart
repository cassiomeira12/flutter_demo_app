import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class PasswordValidationBottomSheet extends StatelessWidget
    with PasswordValidator {
  final UserEntity _user;
  final LoginUseCase _loginUseCase;

  PasswordValidationBottomSheet({
    super.key,
    required this._user,
    required this._loginUseCase,
  });

  final _formKey = GlobalKey<FormState>();
  final passwordTextController = TextEditingController();

  static Future<bool?> show(BuildContext context) async {
    return await BottomSheetWidget.show(
      context: context,
      child: PasswordValidationBottomSheet(
        user: AppBinding.find(),
        loginUseCase: AppBinding.find(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget('password_validation'.tr),
          const SpacerWidget(),
          TextFieldWidget(
            key: const Key('password_input_key'),
            label: 'password_label'.tr,
            hintText: 'password_input_hint'.tr,
            controller: passwordTextController,
            validator: passwordValidator,
            obscureText: true,
          ),
          const SpacerWidget(height: 2),
          FutureButton(
            key: const Key('login_button_key'),
            text: 'confirm'.tr,
            expandWidth: true,
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                FocusManager.instance.primaryFocus?.unfocus();

                final String username = _user.username;
                final String password = passwordTextController.text.trim();

                try {
                  await _loginUseCase.call(
                    username: username,
                    password: password,
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                } on BaseException catch (error) {
                  if (!context.mounted) return;
                  await DialogWidget.showError(
                    context,
                    message: error.message.tr,
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              }
            },
          ),
          const SpacerWidget(height: 2),
        ],
      ),
    );
  }
}
