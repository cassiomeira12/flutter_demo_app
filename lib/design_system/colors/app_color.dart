import 'package:flutter/material.dart';

class AppColor extends Color {
  AppColor(super.value);
}

abstract class AppColors {
  static AppColor primary = AppColor(0xFF17192D);
  static AppColor secondary = AppColor(0xFF2188FF);

  static AppColor tertiaryLigth = AppColor(0xFF17192D);
  static AppColor tertiaryDark = AppColor(0xFF2188FF);

  static AppColor neutral = AppColor(0xFFD8DFE6);
  static AppColor neutralBlack = AppColor(0xFF77818C);
  static AppColor neutralWhite = AppColor(0xFFEAEFF3);
  static AppColor neutralGray = AppColor(0xFFEAEFF3);

  static AppColor transparent = AppColor(0x00000000);

  // Alerts Colors
  static AppColor statusInfo = AppColor(0xFF28A777);
  static AppColor statusSuccess = AppColor(0xFF28A777);
  static AppColor statusError = AppColor(0xFFED3833);
  static AppColor statusWarning = AppColor(0xFFFFC107);

  static AppColor background = AppColor(0xFFFFFFFF);
  static AppColor divider = AppColor(0xFFEAEEF2);
  static AppColor green = AppColor(0xFF52C41A);

  // Neutral Colors
  static AppColor black = AppColor(0x0ff00000);
  static AppColor dark = AppColor(0xFF343A40);
  static AppColor muted = AppColor(0xFF757D6C);
  static AppColor grey = AppColor(0xFFd3d1cb);
  static AppColor light = AppColor(0xFFe8e9e9);
  static AppColor white = AppColor(0xFFffffff);
}
