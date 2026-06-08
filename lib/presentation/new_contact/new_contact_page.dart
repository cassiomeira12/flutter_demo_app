import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/presentation/new_contact/new_contact_controller.dart';

class NewContactPage extends AppView<NewContactController> {
  final _formKey = GlobalKey<FormState>();

  NewContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'new_contact'.tr,
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
                    TextFieldWidget(
                      key: const Key('name_input_key'),
                      label: 'safety_contact_name'.tr,
                      hintText: 'safety_contact_name_description'.tr,
                      controller: controller.nameTextController,
                      validator: controller.nameValidator,
                      keyboardType: TextInputType.name,
                    ),
                    // SpacerWidget(height: 2),
                    // TextFieldWidget(
                    //   key: const Key('phone_input_key1'),
                    //   label: 'WhatsApp',
                    //   hintText: '(00) 0 0000-0000',
                    //   controller: _phoneController,
                    //   validator: controller.phoneNumberValidator,
                    //   keyboardType: TextInputType.phone,
                    //   onChanged: (value) {
                    //     _phoneNumber = value.toString();
                    //   },
                    // ),
                    const SpacerWidget(height: 2),
                    Obx(() {
                      return PhoneFieldWidget(
                        key: const Key('phone_input_key'),
                        label: 'WhatsApp',
                        initialCountry:
                            controller.intialPhoneNumber.value.contains('+')
                            ? null
                            : 'BR',
                        initialValue:
                            controller.intialPhoneNumber.value.contains('+')
                            ? controller.intialPhoneNumber.value
                            : 'BR',
                        searchText: 'search_country'.tr,
                        hintText: '(00) 0 0000-0000',
                        controller: controller.phoneController,
                        validator: controller.phoneNumberValidator,
                        onChanged: (value) {
                          controller.phoneNumber = value;
                        },
                        inputFormatters: const [
                          // if (controller.intialPhoneNumber.value.isNotEmpty)
                          //   BlockedCursorInputFormatter(),
                        ],
                      );
                    }),
                    const SpacerWidget(height: 2),
                    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                      SecondaryButton(
                        key: const Key('search_contacts_list_key'),
                        text: 'search_contact_list'.tr,
                        expandWidth: true,
                        onPressed: () async {
                          try {
                            final contact = await controller.getLocalContact();
                            controller.nameTextController.value =
                                TextEditingValue(text: contact.name);
                            controller.intialPhoneNumber.value =
                                contact.phoneNumber;
                            controller.phoneController.value = TextEditingValue(
                              text: contact.phoneNumber,
                            );
                            _formKey.currentState?.validate();
                          } catch (error) {
                            if (!context.mounted) return;
                            DialogWidget.show(
                              context,
                              title: 'default_error'.tr,
                              message: error.toString().tr,
                            );
                          }
                        },
                      ),
                    const SpacerWidget(height: 3),
                    Obx(() {
                      return CheckboxTitleWidget(
                        text: 'send_message_to_whatsapp_contact'.tr,
                        initialValue: controller.sendMessageToContact.value,
                        onChanged: (value) {
                          controller.sendMessageToContact.value = value;
                        },
                      );
                    }),
                    const SpacerWidget(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: ResponsiveSizeHelper.maxWidth,
                      ),
                      child: TextWidget(
                        'send_message_to_whatsapp_contact_description'.tr,
                        style: AppTextStyle.footnote(context),
                      ),
                    ),
                    const SpacerWidget(height: 5),
                    FutureButton(
                      key: const Key('save_new_contact_button_key'),
                      text: 'save'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final String name = controller.nameTextController.text
                              .trim();
                          final String phoneNumber = controller.phoneNumber
                              .trim();
                          final bool sendMessage =
                              controller.sendMessageToContact.value;

                          try {
                            await controller.createSafetyContact(
                              name: name,
                              phoneNumber: phoneNumber,
                              sendMessage: sendMessage,
                            );
                            if (!context.mounted) return;
                            DialogWidget.show(
                              context,
                              title: 'new_safety_contact_success_title'.tr,
                              message: 'new_safety_contact_success_message'.tr,
                            ).whenComplete(() {
                              if (context.mounted) {
                                controller.backPage(result: true);
                              }
                            });
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
