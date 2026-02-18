import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final Color? color;
  final IconSize size;

  const AppIcon(this.icon, {super.key, this.color, this.size = IconSize.small});

  @override
  Widget build(BuildContext context) {
    if (icon.value.contains('.svg')) {
      return SvgPicture.asset(
        icon.value,
        colorFilter: ColorFilter.mode(
          color ?? Theme.of(context).popupMenuTheme.iconColor!,
          BlendMode.srcIn,
        ),
        width: size.value,
        height: size.value,
      );
    }
    if (icon.value.contains('.png')) {
      return Image.asset(
        icon.value,
        color: color ?? Theme.of(context).popupMenuTheme.iconColor,
        width: size.value,
        height: size.value,
      );
    }
    return const SizedBox.shrink();
  }
}

class AppIcons {
  final String value;

  const AppIcons(this.value);

  static AppIcons logo = const AppIcons(AppAssets.logo);
  static AppIcons maintenance = const AppIcons(AppAssets.maintenance);
  static AppIcons updateAvailable = const AppIcons(AppAssets.updateAvailable);

  static AppIcons bell = const AppIcons(AppAssets.bell);
}
