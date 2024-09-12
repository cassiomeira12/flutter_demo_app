import '../helpers/responsive_size_helper.dart';

class ButtonSize {
  static const ButtonSize large = ButtonSize._(300, 45);
  static const ButtonSize medium = ButtonSize._(180, 35);
  static const ButtonSize small = ButtonSize._(110, 30);

  final double _baseWidth;
  final double _baseHeight;

  const ButtonSize._(this._baseWidth, this._baseHeight);

  double get width => ResponsiveSizeHelper.width(_baseWidth);
  double get height => ResponsiveSizeHelper.height(_baseHeight);
}
