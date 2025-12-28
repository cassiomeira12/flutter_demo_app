import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/credential/credential.dart';
import 'package:flutter_demo_app/presentation/credentials/widgets/otp_widget.dart';

class CredentialPage extends AppView<CredentialController> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _urlFormKey = GlobalKey<FormState>();

  CredentialPage({super.key}) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _passwordFormKey.currentState?.validate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'credential'.tr,
      controller: controller,
      appBarPopUpMenuItems: controller.hasCredential
          ? [
              PopupMenuItem(
                key: const Key('credential_remove_popup_menu_item_key'),
                value: 'remove'.tr,
                onTap: controller.removerCredential,
                child: TextWidget(
                  'remove'.tr,
                ),
              ),
            ]
          : null,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveSizeHelper.width(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Obx(() {
                      if (controller.showOpenUrl.value) {
                        return Container(
                          width: ResponsiveSizeHelper.width(56),
                          height: ResponsiveSizeHelper.width(56),
                          margin: EdgeInsets.only(
                            bottom: ResponsiveSizeHelper.height(8),
                          ),
                          child: ImageWidget(
                            imageUrl: controller.favIconUrl.value,
                          ),
                        );
                      }
                      return SizedBox.fromSize();
                    }),
                    TextFieldWidget(
                      key: const Key('credential_name_input_key'),
                      label: 'name'.tr,
                      hintText: 'credential_name'.tr,
                      controller: controller.credentialNameTextController,
                      validator: controller.nameValidator,
                      keyboardType: TextInputType.name,
                      enableClearTextSuffixIcon: true,
                    ),
                    const SpacerWidget(height: 2),
                    SizedBox(
                      width: ResponsiveSizeHelper.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextFieldWidget(
                              key: const Key('username_input_key'),
                              label: 'username'.tr,
                              hintText: 'credential_username'.tr,
                              controller: controller.userNameTextController,
                              textCapitalization: TextCapitalization.none,
                              enableClearTextSuffixIcon: true,
                            ),
                          ),
                          if (controller.hasCredential)
                            ExcludeFocus(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      ResponsiveSizeHelper.spacingDefaultWidth,
                                ),
                                child: IconButtonWidget(
                                  splashRadius: 15,
                                  icon: FlutterIcon(
                                    Icons.copy,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    final text = controller
                                        .userNameTextController
                                        .text
                                        .trim();
                                    controller.copyText(text).then((_) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          content: TextWidget(
                                            'username_copied'.tr,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    SizedBox(
                      width: ResponsiveSizeHelper.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Form(
                              key: _passwordFormKey,
                              child: TextFieldWidget(
                                key: const Key('password_input_key'),
                                label: 'password_label'.tr,
                                hintText: 'password_label'.tr,
                                controller: controller.passwordTextController,
                                validator: controller.passwordValidator,
                                obscureText: true,
                                textCapitalization: TextCapitalization.none,
                                enableClearTextSuffixIcon: true,
                                onChanged: (String? input) {
                                  _passwordFormKey.currentState?.validate();
                                },
                              ),
                            ),
                          ),
                          if (controller.hasCredential)
                            ExcludeFocus(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  left:
                                      ResponsiveSizeHelper.spacingDefaultWidth,
                                ),
                                child: IconButtonWidget(
                                  splashRadius: 15,
                                  icon: FlutterIcon(
                                    Icons.copy,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    final text = controller
                                        .passwordTextController
                                        .text
                                        .trim();
                                    controller.copyText(text).then((_) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          content: TextWidget(
                                            'password_copied'.tr,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    SizedBox(
                      width: ResponsiveSizeHelper.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextFieldWidget(
                              key: const Key('secret_key_otp_input_key'),
                              label: 'credential_secret_otp'.tr,
                              hintText: '************'.tr,
                              controller: controller.secretKeyOTPTextController,
                              validator: controller.secretOtpValidator,
                              obscureText: true,
                              textCapitalization: TextCapitalization.characters,
                              enableClearTextSuffixIcon: true,
                            ),
                          ),
                          Obx(() {
                            if (controller.showOtpWidget.value) {
                              return ExcludeFocus(
                                child: Container(
                                  height: kToolbarHeight,
                                  padding: EdgeInsets.only(
                                    left: ResponsiveSizeHelper.width(12),
                                  ),
                                  child: OtpWidget(
                                    initialShow: true,
                                    secretKeyOTP: controller
                                        .secretKeyOTPTextController
                                        .text,
                                    getOtpCodeUseCase: AppBinding.find(),
                                    clipboardUeCase: AppBinding.find(),
                                  ),
                                ),
                              );
                            }
                            return Platform.isWeb
                                ? const SizedBox.shrink()
                                : ExcludeFocus(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 16,
                                        left: ResponsiveSizeHelper
                                            .spacingDefaultWidth,
                                      ),
                                      child: IconButtonWidget(
                                        splashRadius: 15,
                                        icon: FlutterIcon(
                                          Icons.qr_code,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed:
                                            controller.readSecretOTPQrCode,
                                      ),
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    SizedBox(
                      width: ResponsiveSizeHelper.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Form(
                              key: _urlFormKey,
                              child: TextFieldWidget(
                                key: const Key('url_input_key'),
                                label: 'Url'.tr,
                                hintText: 'https://google.com.br'.tr,
                                controller: controller.urlTextController,
                                validator: controller.urlValidation,
                                keyboardType: TextInputType.url,
                                textCapitalization: TextCapitalization.none,
                                enableClearTextSuffixIcon: true,
                                onChanged: (String? input) {
                                  _urlFormKey.currentState?.validate();
                                },
                              ),
                            ),
                          ),
                          Obx(() {
                            if (controller.showOpenUrl.value) {
                              return ExcludeFocus(
                                child: Row(
                                  spacing:
                                      ResponsiveSizeHelper.spacingDefaultWidth,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButtonWidget(
                                      splashRadius: 15,
                                      icon: FlutterIcon(
                                        Icons.open_in_new,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: controller.openUrl,
                                    ),
                                    IconButtonWidget(
                                      splashRadius: 15,
                                      icon: FlutterIcon(
                                        Icons.copy,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        final text = controller
                                            .urlTextController
                                            .text
                                            .trim();
                                        controller.copyText(text).then((_) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).primaryColor,
                                              content: TextWidget(
                                                'url_link_copied'.tr,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                    const SpacerWidget(height: 2),
                    TextAreaFieldWidget(
                      key: const Key('notes_input_key'),
                      label: 'notes'.tr,
                      hintText: 'credential_notes'.tr,
                      controller: controller.notesTextController,
                      maxLines: 7,
                    ),
                    if (controller.hasCredential)
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: ResponsiveSizeHelper.maxWidth,
                        ),
                        padding: EdgeInsets.only(
                          top: ResponsiveSizeHelper.spacingDefaultHeight * 2,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextRichWidget(
                                text: '${'updated'.tr}: ',
                                style: AppTextStyle.label(context, bold: true),
                                children: [
                                  TextRichWidget(
                                    text: controller.updatedAt ?? '',
                                    style: AppTextStyle.label(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SpacerWidget(height: 3),
                    FutureButton(
                      key: const Key('save_button_key'),
                      text: 'save'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        final bool defaultValidation =
                            _formKey.currentState?.validate() ?? false;
                        final bool urlValidation =
                            _urlFormKey.currentState?.validate() ?? false;
                        if (defaultValidation && urlValidation) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final String credentialName = controller
                              .credentialNameTextController
                              .value
                              .text
                              .trim();
                          final String userName = controller
                              .userNameTextController
                              .value
                              .text
                              .trim();
                          final String password = controller
                              .passwordTextController
                              .value
                              .text
                              .trim();
                          final String secretKeyOTP = controller
                              .secretKeyOTPTextController
                              .value
                              .text
                              .trim();
                          final String url = controller
                              .urlTextController
                              .value
                              .text
                              .trim();
                          final String notes = controller
                              .notesTextController
                              .value
                              .text
                              .trim();

                          try {
                            await controller.saveCredential(
                              credentialName: credentialName,
                              userName: userName,
                              password: password,
                              secretKeyOTP: secretKeyOTP,
                              url: url,
                              notes: notes,
                            );
                          } on BaseException catch (error) {
                            if (!context.mounted) return;

                            DialogWidget.show(
                              context,
                              title: 'default_error'.tr,
                              message: error.toString().tr,
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
