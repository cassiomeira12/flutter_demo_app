// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/app_assets.dart';
import '../colors/app_color.dart';
import 'icon_size.dart';

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final AppColor? color;
  final IconSize size;

  const AppIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = IconSize.small,
  });

  @override
  Widget build(BuildContext context) {
    if (icon.value.contains('.svg')) {
      return SvgPicture.asset(
        icon.value,
        color: color ?? Theme.of(context).iconTheme.color,
        width: size.value,
        height: size.value,
      );
    }
    if (icon.value.contains('.png')) {
      return Image.asset(
        icon.value,
        color: color ?? Theme.of(context).iconTheme.color,
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
  static AppIcons company = const AppIcons(AppAssets.company);
  static AppIcons back = const AppIcons(AppAssets.back);

  static AppIcons bolt = const AppIcons(AppAssets.bolt);
  static AppIcons energy = const AppIcons(AppAssets.boltFill);
  static AppIcons info = const AppIcons(AppAssets.info);
  static AppIcons search = const AppIcons(AppAssets.search);
  static AppIcons arrowDown = const AppIcons(AppAssets.switcher);
  static AppIcons alert = const AppIcons(AppAssets.dot);
}
