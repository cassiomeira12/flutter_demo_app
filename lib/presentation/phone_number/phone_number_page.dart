import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/presentation/phone_number/phone_number_controller.dart';

class PhoneNumberPage extends AppView<PhoneNumberController> {
  final _formKey = GlobalKey<FormState>();

  PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'phone_number'.tr,
      controller: controller,
      appBarLeading: Navigator.canPop(context)
          ? null
          : BackButton(
              onPressed: () async {
                final bool? result = await DialogWidget.showChoice(
                  context,
                  title: 'logout'.tr,
                  message: 'logout_app_message'.tr,
                  okButton: 'logout'.tr,
                );
                if (result == true) {
                  await controller.logout();
                }
              },
            ),
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
                    const SpacerWidget(height: 2),
                    TextWidget(
                      'add_whatsapp_number'.tr,
                    ),
                    const SpacerWidget(height: 2),
                    PhoneFieldWidget(
                      key: const Key('phone_input_key'),
                      label: 'WhatsApp',
                      initialCountry: 'BR',
                      searchText: 'search_country'.tr,
                      hintText: '(00) 0 0000-0000',
                      controller: controller.phoneControler,
                      validator: controller.phoneNumberValidator,
                      onChanged: (value) {
                        if (value.length < controller.phoneNumber.length) {
                          controller.typeCode.value = false;
                        }
                        controller.phoneNumber = value;
                      },
                    ),
                    const SpacerWidget(),
                    TextWidget(
                      'you_will_receive_code'.tr,
                      style: AppTextStyle.label(context),
                    ),
                    Obx(() {
                      return Visibility(
                        visible: controller.typeCode.value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpacerWidget(height: 3),
                            const TextWidget(
                              'type_the_received_whatsapp_code',
                              // style: fontMessage(context),
                            ),
                            const SpacerWidget(),
                            if (controller.typeCode.value)
                              PinFieldWidget(
                                pinLength: 4,
                                validator: controller.codeValidator,
                                onCompleted: (value) {
                                  controller.code = value;
                                },
                              ),
                            const SpacerWidget(),
                            LightButton(
                              text: 'send_new_code'.tr,
                              onPressed: () {
                                //controller.onReady();
                                //controller.checkWhatsAppNumber(_phoneNumber);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const SpacerWidget(height: 5),
                    FutureButton(
                      text: 'save'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          try {
                            if (!controller.typeCode.value) {
                              await controller.sendWhatsAppCode(
                                phoneNumber: controller.phoneNumber,
                              );
                            } else {
                              _formKey.currentState?.save();
                              await controller.savePhoneNumber(
                                phoneNumber: controller.phoneNumber,
                                code: controller.code,
                              );
                            }

                            // DialogWidget.show(
                            //   context,
                            //   title: 'recovery_password_success_title'.tr,
                            //   message: 'recovery_password_success_message'.tr,
                            // );
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
                    const SpacerWidget(height: 3),
                    Visibility(
                      visible: controller.user.phoneVerified == false,
                      child: LightButton(
                        text: 'allow_later'.tr,
                        onPressed: controller.verifiedPhoneNumberLater,
                      ),
                    ),
                    const SpacerWidget(height: 5),
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
