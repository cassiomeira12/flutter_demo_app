import 'package:design_system/design_system.dart';

enum TextSize {
  font_98._(98),
  font_61._(61),
  font_49._(49),
  font_35._(35),
  font_32._(32),
  font_24._(24),
  font_20._(20),
  font_16._(16),
  font_14._(14),
  font_12._(12),
  font_10._(10),
  font_8._(8);

  final double _baseValue;

  const TextSize._(this._baseValue);

  double get value => ResponsiveSizeHelper.width(_baseValue);
}
