import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  final FlutterIcon icon;
  final VoidCallback onPressed;

  const FloatingButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('FloatingButtonWidget', name: 'Rebuild');
    return FloatingActionButton(
      heroTag: GlobalKey(),
      child: icon,
      onPressed: () {
        onPressed.call();
        HapticFeedback.lightImpact();
      },
    );
  }
}
