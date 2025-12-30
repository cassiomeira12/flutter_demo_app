import 'package:dependency/dependency.dart';

extension HexColorExtension on String {
  Color toColor() {
    String hex = replaceAll('#', '').toUpperCase();

    // Se tiver 6 caracteres, adiciona FF (opacidade máxima)
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    // Agora deve ter 8 caracteres (AARRGGBB)
    if (hex.length != 8) {
      throw FormatException("Hex color inválido: $this");
    }

    return Color(int.parse(hex, radix: 16));
  }
}

extension ColorExtension on Color {
  //
}

// Color _getContrastingTextColor(Color backgroundColor, BuildContext context) {
//   final whiteContrast = _calculateContrastRatio(
//     backgroundColor,
//     HuxTokens.textInvert(context),
//   );
//   final blackContrast = _calculateContrastRatio(
//     backgroundColor,
//     HuxTokens.textPrimary(context),
//   );

//   // Choose the color with better contrast
//   return whiteContrast > blackContrast
//       ? HuxTokens.textInvert(context)
//       : HuxTokens.textPrimary(context);
// }

/// Calculates the relative luminance of a color according to WCAG guidelines
// double _getRelativeLuminance(Color color) {
//   // Convert RGB values to 0-1 range
//   final r = color.r / 255.0;
//   final g = color.g / 255.0;
//   final b = color.b / 255.0;

//   // Apply gamma correction
//   final rLinear = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
//   final gLinear = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
//   final bLinear = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

//   // Calculate relative luminance using ITU-R BT.709 coefficients
//   return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
// }

// /// Calculates contrast ratio between two colors
// double _calculateContrastRatio(Color color1, Color color2) {
//   final luminance1 = _getRelativeLuminance(color1);
//   final luminance2 = _getRelativeLuminance(color2);

//   final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
//   final darker = luminance1 > luminance2 ? luminance2 : luminance1;

//   return (lighter + 0.05) / (darker + 0.05);
// }
