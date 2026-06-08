import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final double? splashRadius;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.focusNode,
    this.splashRadius,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('IconButtonWidget', name: 'Rebuild');
    return IconButton(
      icon: icon,
      focusNode: focusNode,
      splashRadius: splashRadius,
      onPressed: () {
        onPressed.call();
        HapticFeedback.lightImpact();
      },
    );
  }
}
