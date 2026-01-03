import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AppTextStyle extends TextStyle {
  AppTextStyle.title(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.black,
    TextSize fontSize = TextSize.font_24,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.subtitle(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_16,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.message(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.error(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_12,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: Theme.of(context).colorScheme.error,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.label(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_10,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.field(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.medium,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.button(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.medium,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.titleLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.hyperlink(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         decoration: TextDecoration.underline,
         fontFeatures: [const FontFeature.tabularFigures()],
       );

  AppTextStyle.footnote(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.light,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
    super.decoration,
  }) : super(
         fontFamily: fontFamily.family,
         fontSize: fontSize.value,
         color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
         fontWeight: bold ? FontWeight.bold : FontWeight.w900,
         fontFeatures: [const FontFeature.tabularFigures()],
       );
}
