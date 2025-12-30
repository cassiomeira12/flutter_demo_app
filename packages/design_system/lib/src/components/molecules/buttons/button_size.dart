import 'package:design_system/design_system.dart';

enum ButtonSize {
  large._(300, 45),
  medium._(180, 35),
  small._(110, 32);

  final double rawWidth;
  final double rawHeight;

  const ButtonSize._(this.rawWidth, this.rawHeight);

  double get width => ResponsiveSizeHelper.width(rawWidth);
  double get height => ResponsiveSizeHelper.height(rawHeight);
}
