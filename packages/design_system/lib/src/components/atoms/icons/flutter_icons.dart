import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class FlutterIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
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
      size: size.value,
      color:
          color ??
          Theme.of(
            context,
          ).iconButtonTheme.style?.iconColor?.resolve({WidgetState.selected}),
    );
  }

  FlutterIcon copyWith({IconData? icon, Color? color, IconSize? size}) {
    return FlutterIcon(
      icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
