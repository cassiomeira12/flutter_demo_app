import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../font/font_family.dart';
import 'text_size.dart';

class AppTextStyle extends TextStyle {
  AppTextStyle.title(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.black,
    TextSize fontSize = TextSize.font_24,
    AppColor? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w700,
        );

  AppTextStyle.subtitle(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_16,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        );

  AppTextStyle.message(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        );

  AppTextStyle.label(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.regular,
    TextSize fontSize = TextSize.font_10,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        );

  AppTextStyle.field(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.medium,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        );

  AppTextStyle.button(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.medium,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        );

  AppTextStyle.hyperlink(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.thin,
    TextSize fontSize = TextSize.font_14,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
          decoration: TextDecoration.underline,
        );

  AppTextStyle.footnote(
    BuildContext context, {
    FontFamily fontFamily = FontFamily.light,
    TextSize fontSize = TextSize.font_12,
    Color? color,
    super.overflow,
    bool bold = false,
  }) : super(
          fontFamily: fontFamily.family,
          fontSize: fontSize.value,
          color: color ?? Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        );
}
