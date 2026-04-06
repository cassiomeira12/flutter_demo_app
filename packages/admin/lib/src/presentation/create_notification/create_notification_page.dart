import 'package:admin/src/presentation/create_notification/create_notification.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PushNotificationsPage extends AppView<PushNotificationsController> {
  final _formKey = GlobalKey<FormState>();

  PushNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'push_notifications'.tr,
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
                      controller: controller.titleController,
                      label: 'Título da notificação',
                      hintText: 'Insira um título opicional',
                      validator: controller.titleValidator,
                    ),
                    const SpacerWidget(),
                    TextFieldWidget(
                      controller: controller.bodyController,
                      label: 'Texto da notificação',
                      hintText: 'Insira o texto de notificação',
                      validator: controller.bodyValidator,
                    ),
                    const SpacerWidget(),
                    TextFieldWidget(
                      controller: controller.imageController,
                      label: 'URL da Imagem (opicional)',
                      hintText: 'Insira a URL de uma imagem',
                      validator: (_) => null,
                    ),
                    const SpacerWidget(),
                    TextFieldWidget(
                      controller: controller.userController,
                      label: 'Destinário',
                      hintText: 'Pesquise pelo nome do usuário',
                      validator: (_) => null,
                    ),
                    /*AutoCompleteFieldWidget<UserEntity>(
                    label: 'Destinário',
                    hintText: 'Pesquise pelo nome do usuário',
                    getName: (item) => (item as UserEntity).name,
                    items: controller.searchUsers,
                    fetchOnInit: true,
                    // items: (query, take, skip) async {
                    //   await Future.delayed(const Duration(seconds: 1));
                    //   return [
                    //     'teste',
                    //   ];
                    // },
                    // itemBuilder: (BuildContext context, UserEntity item) {
                    //   return UserWidget(
                    //     user: item,
                    //     onTap: () {
                    //       //
                    //     },
                    //   );
                    // },
                    onSelected: (value) {
                      controller.userSelected = (value as UserEntity?);
                    },
                    hideSuggestions: true,
                    suggestItems: [controller.user],
                  ),*/
                    const SpacerWidget(height: 2),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: ResponsiveSizeHelper.maxWidth,
                      ),
                      child: Row(
                        children: [
                          const Flexible(
                            child: TextWidget(
                              'Envie esta notificação de teste para este dispositivo',
                            ),
                          ),
                          const SpacerWidget(),
                          SecondaryButton(
                            text: 'Enviar teste',
                            size: ButtonSize.small,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                FocusManager.instance.primaryFocus?.unfocus();

                                final String title = controller
                                    .titleController
                                    .text
                                    .trim();
                                final String body = controller
                                    .bodyController
                                    .text
                                    .trim();
                                final String imageUrl = controller
                                    .imageController
                                    .text
                                    .trim();

                                final result = await controller.testPush(
                                  title: title,
                                  body: body,
                                  imageUrl: imageUrl.isEmpty ? null : imageUrl,
                                );

                                if (!context.mounted) return;

                                if (result is Error) {
                                  DialogWidget.showError(
                                    context,
                                    message: result.error.message.tr,
                                  );
                                } else {
                                  DialogWidget.show(
                                    context,
                                    title:
                                        'notification_created_success_title'.tr,
                                    message:
                                        'notification_created_success_message'
                                            .tr,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(height: 3),
                    FutureButton(
                      expandWidth: true,
                      text: 'Enviar mensagem',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final String title = controller.titleController.text
                              .trim();
                          final String body = controller.bodyController.text
                              .trim();
                          final String imageUrl = controller
                              .imageController
                              .text
                              .trim();
                          final UserEntity user = controller.userSelected!;

                          try {
                            await controller.createNotification(
                              title: title,
                              body: body,
                              imageUrl: imageUrl.isEmpty ? null : imageUrl,
                              user: user,
                            );

                            if (!context.mounted) return;

                            await DialogWidget.show(
                              context,
                              title: 'notification_created_success_title'.tr,
                              message:
                                  'notification_created_success_message'.tr,
                            );

                            if (!context.mounted) return;

                            controller.titleController.clear();
                            controller.bodyController.clear();
                            controller.imageController.clear();
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
