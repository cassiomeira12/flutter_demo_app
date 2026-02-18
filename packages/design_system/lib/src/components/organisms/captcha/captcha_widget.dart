import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CaptchaWidget extends StatefulWidget {
  final Function() onSuccess;

  const CaptchaWidget({super.key, required this.onSuccess});

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  final _textEditingController = TextEditingController();
  final _localCaptchaController = LocalCaptchaController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _localCaptchaController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSizeHelper.maxWidth * .7,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpacerWidget(),
              TextWidget(
                'fill_the_captcha'.tr,
                style: AppTextStyle.subtitle(context),
              ),
              const SpacerWidget(),
              LocalCaptcha(
                controller: _localCaptchaController,
                width: constraints.maxWidth,
                height: ResponsiveSizeHelper.height(200),
                chars: '123456789',
                length: 4,
                fontSize: TextSize.font_61.value,
                codeExpireAfter: const Duration(minutes: 1),
              ),
              const SpacerWidget(),
              LightButton(
                text: 'generate_new_captcha_code'.tr,
                textStyle: AppTextStyle.button(
                  context,
                  decoration: TextDecoration.underline,
                ),
                onPressed: () {
                  _localCaptchaController.refresh();
                  _textEditingController.clear();
                },
              ),
              const SpacerWidget(),
              PinFieldWidget(
                pinLength: 4,
                focusNode: _focusNode,
                autofocus: Platform.isMobile,
                controller: _textEditingController,
                validator: (String? value) {
                  final result = _localCaptchaController.validate(value!);
                  if (result == LocalCaptchaValidation.valid) {
                    widget.onSuccess.call();
                  } else {
                    _textEditingController.clear();
                    _localCaptchaController.refresh();
                    Future.delayed(const Duration(milliseconds: 500)).then((_) {
                      if (Platform.isMobile) {
                        _focusNode.requestFocus();
                      }
                    });
                  }
                  return null;
                },
              ),
              const SpacerWidget(),
            ],
          );
        },
      ),
    );
  }
}
