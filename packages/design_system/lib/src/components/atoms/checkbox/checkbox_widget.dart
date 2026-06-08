// ignore_for_file: must_be_immutable

import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class CheckboxWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final Color? checkColor;
  final Color? borderColor;

  bool value;

  CheckboxWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkColor,
    this.borderColor,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    developer.log('CheckBoxWidget ${widget.value}', name: 'Rebuild');
    return SizedBox(
      width: ResponsiveSizeHelper.width(25),
      height: ResponsiveSizeHelper.height(25),
      child: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: widget.value,
        onChanged: (value) {
          widget.onChanged.call(value!);
          setState(() => widget.value = value);
          HapticFeedback.lightImpact();
        },
        checkColor:
            widget.checkColor ?? Theme.of(context).scaffoldBackgroundColor,
        side: BorderSide(
          width: 2,
          color: widget.borderColor ?? Theme.of(context).iconTheme.color!,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Theme.of(context).cardColor
              : Colors.transparent;
        }),
      ),
    );
  }
}
