import 'dart:ui';

import 'package:flutter/material.dart';

class BlurEffectWidget extends StatelessWidget {
  final bool enabled;
  final bool ignorePointer;
  final Widget child;

  const BlurEffectWidget({
    super.key,
    required this.enabled,
    required this.ignorePointer,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      enabled: enabled,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: IgnorePointer(
        ignoring: ignorePointer,
        child: child,
      ),
    );
  }
}
