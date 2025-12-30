import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

abstract class AppColors {
  // static const Color primaryLight = Color(0xFF45B39C);
  // static const Color secondaryLight = Color(0xFF2188FF);
  // static const Color tertiaryLight = Color(0xFF17192D);

  // https://mdigi.tools/darken-color/
  // static const Color primaryDark = Color(0xFF307D6D);
  // static const Color secondaryDark = Color(0xFF005ECA);
  // static const Color tertiaryDark = Color(0xFF17192D);

  static const Color scaffoldBackgroundLight = Color(
    0xFFF2F2F2,
  ); // NeutralColors.neutral50;
  static const Color scaffoldBackgroundDark = NeutralColors.neutral900;

  static const Color highlightBackgroundColorLight = StaticColors.white;
  static const Color highlightBackgroundColorDark = NeutralColors.neutral800;

  static const Color disabledColorLight = NeutralColors.neutral100;
  static const Color disabledColorDark = NeutralColors.neutral500;

  static const Color dividerColorLight = NeutralColors.neutral400;
  static const Color dividerColorDark = NeutralColors.neutral500;

  static const Color bottomNavigationColorLight = StaticColors.white;
  static const Color bottomNavigationColorDark = Color(0xFF121212);

  static const Color textColorLight = NeutralColors.neutral900;
  static const Color textColorDark = Color(0xFFDEDEDE);

  static const Color buttonTextColorLight = scaffoldBackgroundLight;
  static const Color buttonTextColorDark = AppColors.white;

  static const Color outlinedButtonTextColorLight = textColorLight;
  static const Color outlinedButtonTextColorDark = NeutralColors.neutral100;

  static const Color outlinedButtonIconColorLight = textColorLight;
  static const Color outlinedButtonIconColorDark = dividerColorDark;

  // Others Colors

  static const Color statusInfo = SemanticColors.informative600;
  static const Color statusSuccess = SemanticColors.positive600;
  static const Color statusError = SemanticColors.negative600;
  static const Color statusWarning = SemanticColors.warning400;

  // static const Color green = Color(0xFF52C41A);
  static const Color yellow = Color(0xFFFFEB3B);

  // static const Color unselectedWhite = Color(0xFF616C7A);
  // static const Color unselectedDark = Color(0xFF616B7A);

  static const Color black = StaticColors.black;
  // static const Color dark = Color(0xFF121212);
  // static const Color muted = Color(0xFF757D6C);
  // static const Color gray = Color(0xFFd3d1cb);
  // static const Color light = Color(0xFFf4f4f4);
  static const Color white = StaticColors.white;
  static const Color transparent = StaticColors.transparent;
}
