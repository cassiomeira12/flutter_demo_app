import '../../core/core.dart';
import '../../design_system/design_system.dart';
import 'recovery_password_controller.dart';

class RecoveryPasswordPage extends AppView<RecoveryPasswordController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Recuperar senha',
      controller: controller,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveSizeHelper.width(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(width: 2),
              TextFieldWidget(
                label: 'E-mail',
                hintText: 'Digite seu e-mail',
              ),
              Spacer(),
              PrimaryButton(
                text: 'Recuperar',
                expandWidth: true,
                // onPressed: controller.login,
              ),
              Spacer(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
