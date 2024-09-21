import '../../core/core.dart';
import '../../design_system/design_system.dart';
import 'login_controller.dart';

class LoginPage extends AppView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'app_name'.tr,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveSizeHelper.width(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                'Login',
                style: AppTextStyle.title(context),
              ),
              Spacer(width: 2),
              TextFieldWidget(
                label: 'E-mail',
                hintText: 'Digite seu e-mail',
              ),
              Spacer(),
              TextFieldWidget(
                label: 'Senha',
                hintText: 'Digite sua senha',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              Spacer(width: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: LightButton(
                      text: 'Recuperar senha',
                      onPressed: controller.recoveryPassword,
                    ),
                  ),
                ],
              ),
              Spacer(width: 2),
              PrimaryButton(
                text: 'Entrar',
                expandWidth: true,
                onPressed: controller.login,
              ),
              Spacer(width: 2),
            ],
          ),
        ),
      ),
      bottomWidget: Center(
        child: TextWidget(
          'Não tem uma conta? Clique aqui para criar',
        ),
      ),
    );
  }
}
