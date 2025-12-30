import 'package:design_system/design_system.dart';

/// Represents the size of an icon.
///
/// The *IconSize* enum provides a way to set the size of an icon.
/// Can be used to specify the same value for icon width and height.
/// ---
/// Example usage:
/// ```dart
/// AppIcon.icon(
///   iconData: Icons.access_alarm_outlined,
///   color: DSColor.secondary.color,
///   size: DSIconSize.large.value,
/// ),
/// ```
enum IconSize {
  bigger._(48.0),
  large._(32.0),
  medium._(24.0),
  small._(16.0);

  final double _baseValue;

  const IconSize._(this._baseValue);

  double get value => ResponsiveSizeHelper.width(_baseValue);
}
