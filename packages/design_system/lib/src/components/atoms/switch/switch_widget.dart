// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';
import 'package:flutter/cupertino.dart';

class SwitchWidget extends StatefulWidget {
  bool value;
  final ValueChanged<bool> onChanged;

  SwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 64.pxWidth,
      // height: 32.pxHeight,
      // color: Colors.blue,
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: CupertinoSwitch(
          value: widget.value,
          activeTrackColor: Theme.of(context).cardColor,
          // activeColor: Theme.of(context).hoverColor,
          // thumbColor: value
          //     ? Get.isDarkMode
          //         ? Theme.of(context).primaryColor
          //         : Theme.of(context).tabBarTheme.indicatorColor
          //     : Get.isDarkMode
          //         ? Theme.of(context)
          //             .cupertinoOverrideTheme!
          //             .primaryContrastingColor
          //         : Theme.of(context)
          //             .cupertinoOverrideTheme!
          //             .scaffoldBackgroundColor,
          // trackColor: Theme.of(context).cupertinoOverrideTheme!.primaryColor,
          inactiveTrackColor: Theme.of(context).disabledColor,
          onChanged: (value) {
            widget.onChanged.call(value);
            setState(() => widget.value = value);
            HapticFeedback.lightImpact();
          },
        ),
      ),
    );
  }
}
