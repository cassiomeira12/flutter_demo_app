import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/presentation/feedback/feedback.dart';

class FeedbackPage extends AppView<FeedbackController> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _feedbackTextController = TextEditingController();

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'feedback'.tr,
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
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                  children: [
                    TextWidget(
                      'feedback_title'.tr,
                      style: .subtitle(context, fontSize: .font_14),
                    ),
                    TextWidget(
                      'feedback_message'.tr,
                      style: .footnote(context, fontSize: .font_10),
                    ),
                    TextFieldWidget(
                      key: const Key('name_input_key'),
                      label: 'name'.tr,
                      hintText: 'enter_your_full_name'.tr,
                      controller: _nameTextController,
                      validator: controller.nameValidator,
                      keyboardType: TextInputType.name,
                    ),
                    TextFieldWidget(
                      key: const Key('email_input_key'),
                      label: 'username_label'.tr,
                      hintText: 'username_input_hint'.tr,
                      controller: _emailTextController,
                      validator: controller.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextAreaFieldWidget(
                      key: const Key('notes_input_key'),
                      label: 'suggestion'.tr,
                      controller: _feedbackTextController,
                      validator: controller.feedbackValidator,
                      maxLines: 7,
                    ),
                    TextWidget(
                      'feedback_disclaimer'.tr,
                      style: .footnote(context, fontSize: .font_10),
                    ),
                    FutureButton(
                      text: 'send'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final name = _nameTextController.value.text.trim();
                          final email = _emailTextController.value.text.trim();
                          final feedback = _feedbackTextController.text.trim();

                          try {
                            await controller.sendFeedback(
                              name: name,
                              email: email,
                              feedback: feedback,
                            );
                            _nameTextController.clear();
                            _emailTextController.clear();
                            _feedbackTextController.clear();
                            if (!context.mounted) return;
                            DialogWidget.show(
                              context,
                              title: 'feedback_sent_success_title'.tr,
                              message: 'feedback_sent_success_message'.tr,
                            );
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
