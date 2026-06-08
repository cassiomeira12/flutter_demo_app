import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/presentation/emergency/emergency.dart';
import 'package:flutter_demo_app/presentation/emergency/widgets/ripple/ripple_animation.dart';
import 'package:flutter_demo_app/presentation/emergency/widgets/server_status_widget.dart';

class EmergencyPage extends AppView<EmergencyController> {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'emergency'.tr,
      showNotificationsIcon: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: ResponsiveSizeHelper.height(50),
        children: [
          Obx(() {
            return RipplesAnimation(
              key: const Key('key_sos_button'),
              text: 'SOS',
              controller: controller.animationController,
              size: MediaQuery.of(context).size.width,
              color: controller.sosStatusColor.value,
              // functionOptions: () => CustomDialog.showCustom(context),
              functionOptions: () async {
                return 1;
              },
              onChange: (initAnimation) {
                if (!initAnimation) {
                  final bool cancelled = controller.cancelSendingSOS();
                  if (cancelled) {
                    DialogWidget.show(
                      context,
                      title: 'sos_cancel_tile'.tr,
                      message: 'sos_cancel_message'.tr,
                    );
                  }
                }
              },
              sendSOS: (int choice) async {
                try {
                  final int? messagesSent = await controller.sendSOS(choice);
                  if (!controller.sendSOScancelled && messagesSent != null) {
                    if (!context.mounted) return;
                    DialogWidget.show(
                      context,
                      title: 'sos_send_successful'.tr,
                      message:
                          'Seu pedido foi enviado com sucesso para $messagesSent ${messagesSent > 1 ? 'contatos' : 'contato'}, aguarde as autoridades!',
                    );
                  }
                } catch (error) {
                  controller.animationController.value?.stop();
                  if (!context.mounted) return;
                  DialogWidget.show(
                    context,
                    title: 'Error'.tr,
                    message: error.toString().tr,
                  );
                  rethrow;
                }
              },
            );
          }),
          Obx(() {
            return ServerStatusWidget(
              status: controller.whatsAppServer.value,
              onTap: controller.checkWhatsAppServer,
            );
          }),
          Flexible(
            flex: 2,
            child: TextWidget(
              controller.sosStatusMessage.value,
              textAlign: TextAlign.center,
              style: AppTextStyle.subtitle(
                context,
                bold: true,
              ),
              // style: fontMessage(
              //   context,
              //   bold: true,
              //   size: 18,
              //   // color: controller.sosStatusColor.value,
              //   color: Colors.black,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
