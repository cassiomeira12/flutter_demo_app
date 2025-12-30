import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ThemeBottomSheetWidget extends StatelessWidget {
  final String currentThemeData;
  final Function(String theme) onChangeTheme;

  const ThemeBottomSheetWidget({
    super.key,
    required this.currentThemeData,
    required this.onChangeTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget('choose_theme_app'.tr),
        const SpacerWidget(),
        ...ThemeManager.instance.themes.keys.map((themeName) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSizeHelper.width(20),
              vertical: ResponsiveSizeHelper.height(8),
            ),
            child: SecondaryButton(
              text: '${themeName}_theme'.tr,
              expandWidth: true,
              icon: FlutterIcon(
                currentThemeData == themeName
                    ? BoxIcons.bx_radio_circle_marked
                    : BoxIcons.bx_radio_circle,
                color: currentThemeData == themeName
                    ? theme.primaryColor
                    : theme.iconTheme.color,
                size: IconSize.medium,
              ),
              borderColor: currentThemeData == themeName
                  ? theme.primaryColor
                  : theme.iconTheme.color,
              onPressed: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 500), () {
                  onChangeTheme(themeName);
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
