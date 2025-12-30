// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ToggleButton extends StatefulWidget {
  bool value;
  final String text;
  final ValueChanged<bool> onPressed;
  final AppIcons? icon;
  final bool expandWidth;
  final ButtonSize size;

  ToggleButton({
    super.key,
    required this.value,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: widget.text,
      // borderColor: widget.value ? AppColors.secondary : AppColors.neutral,
      // backgroundColor: widget.value ? AppColors.secondary : null,
      textColor: widget.value ? AppColors.white : null,
      expandWidth: widget.expandWidth,
      size: widget.size,
      onPressed: () {
        setState(() => widget.value = !widget.value);
        widget.onPressed.call(widget.value);
        HapticFeedback.lightImpact();
      },
    );
  }
}
