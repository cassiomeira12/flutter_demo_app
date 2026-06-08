import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class LocaleBottomSheetWidget extends StatelessWidget {
  final Function(Locale locale) onChangeLocale;

  const LocaleBottomSheetWidget({super.key, required this.onChangeLocale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget('language_selection'.tr),
        const SpacerWidget(),
        ...Translation.supportedLocales.map((locale) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSizeHelper.width(20),
              vertical: ResponsiveSizeHelper.height(8),
            ),
            child: SecondaryButton(
              text: locale.languageCode.tr,
              expandWidth: true,
              icon: FlutterIcon(
                Get.locale == locale
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
                color: Get.locale == locale
                    ? theme.primaryColor
                    : theme.iconTheme.color,
                size: IconSize.medium,
              ),
              borderColor: Get.locale == locale
                  ? theme.primaryColor
                  : theme.iconTheme.color,
              onPressed: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 500), () {
                  onChangeLocale(locale);
                });
              },
            ),
          );
        }),
        const SpacerWidget(),
      ],
    );
  }
}
