import '../../core/core.dart';
import '../../design_system/design_system.dart';
import 'about_controller.dart';

class AboutPage extends AppView<AboutController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Sobre o App',
      controller: controller,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          TextWidget(
            'Versão 24.15.0 (123)',
          ),
          Spacer(),
          SecondaryButton(
            text: 'Termos de serviço',
          ),
          Spacer(),
          SecondaryButton(
            text: 'Política de Privacidade',
          ),
          Spacer(),
          SecondaryButton(
            text: 'Visitar website',
          ),
          Spacer(),
        ],
      ),
    );
  }
}
