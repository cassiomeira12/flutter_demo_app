import 'package:flutter/foundation.dart';

abstract class Platform {
  static TargetPlatform? _mockPlatform;

  static TargetPlatform get currentPlatform =>
      _mockPlatform ?? defaultTargetPlatform;

  static void mock(TargetPlatform mock) => _mockPlatform = mock;

  static const List<TargetPlatform> _mobilePlatformList = [
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.fuchsia,
  ];

  static const List<TargetPlatform> _desktopPlatformList = [
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  ];

  static bool get isWeb => kIsWeb;

  static bool get isMobile {
    return !isWeb && _mobilePlatformList.contains(currentPlatform);
  }

  static bool get isDesktop {
    return !isWeb && _desktopPlatformList.contains(currentPlatform);
  }

  static bool get appleDevice {
    return !isWeb &&
        [TargetPlatform.iOS, TargetPlatform.macOS].contains(currentPlatform);
  }

  static bool get isAndroid =>
      !isWeb && currentPlatform == TargetPlatform.android;

  static bool get isIOS => !isWeb && currentPlatform == TargetPlatform.iOS;

  static bool get isMacOS => !isWeb && currentPlatform == TargetPlatform.macOS;
}
