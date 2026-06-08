// ignore_for_file: must_be_immutable

import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:flutter/cupertino.dart';

class SwitchWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  bool value;

  SwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    developer.log('SwitchWidget ${widget.value}', name: 'Rebuild');
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: CupertinoSwitch(
        value: widget.value,
        activeTrackColor: Theme.of(context).cardColor,
        inactiveTrackColor: Theme.of(context).disabledColor,
        onChanged: (value) {
          widget.onChanged.call(value);
          setState(() => widget.value = value);
          HapticFeedback.lightImpact();
        },
      ),
    );
  }
}
