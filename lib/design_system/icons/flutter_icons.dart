import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import 'icon_size.dart';

class FlutterIcon extends StatelessWidget {
  final IconData icon;
  final AppColor? color;
  final IconSize size;

  const FlutterIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = IconSize.small,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color ?? Theme.of(context).iconTheme.color,
      size: size.value,
    );
  }
}
