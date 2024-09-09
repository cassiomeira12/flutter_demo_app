import '../helpers/responsive_size_helper.dart';

class TextSize {
  static const TextSize font_98 = TextSize._(98);
  static const TextSize font_61 = TextSize._(61);
  static const TextSize font_49 = TextSize._(49);
  static const TextSize font_35 = TextSize._(35);
  static const TextSize font_32 = TextSize._(32);
  static const TextSize font_24 = TextSize._(24);
  static const TextSize font_20 = TextSize._(20);
  static const TextSize font_16 = TextSize._(16);
  static const TextSize font_14 = TextSize._(14);
  static const TextSize font_12 = TextSize._(12);
  static const TextSize font_10 = TextSize._(10);
  static const TextSize font_8 = TextSize._(8);

  final double _baseValue;

  const TextSize._(this._baseValue);

  double get value => ResponsiveSizeHelper.width(_baseValue);
}
