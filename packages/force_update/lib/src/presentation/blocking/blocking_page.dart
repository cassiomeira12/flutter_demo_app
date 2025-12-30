import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'blocking.dart';

class BlockingPage extends AppView<BlockingController> {
  const BlockingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      canPop: false,
      title: 'blocking'.tr,
      controller: controller,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
        child: Column(
          children: [
            const SpacerWidget(),
            TextWidget(
              '🐞 Estamos em manutenção',
              style: AppTextStyle.subtitle(context),
            ),
            const SpacerWidget(),
            const TextWidget(
              'O aplicativo está indisponível no momento, em breve você poderá utilizar o App novamente.',
              textAlign: TextAlign.center,
            ),
            const SpacerWidget(height: 2),
            Obx(() {
              return Visibility(
                visible: controller.pushSubcribed.value,
                child: const TextWidget(
                  'Ao finalizar, você será notificado quando o aplicativo estiver disponível novamente.',
                  textAlign: TextAlign.center,
                ),
              );
            }),
            const SpacerWidget(height: 2),
          ],
        ),
      ),
    );
  }
}
