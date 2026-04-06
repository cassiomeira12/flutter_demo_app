// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ToggleButton extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onPressed;
  final AppIcons? icon;
  final bool expandWidth;
  final ButtonSize size;

  bool value;

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
    final theme = Theme.of(context);
    return SecondaryButton(
      text: widget.text,
      borderColor: widget.value ? theme.primaryColor : null,
      backgroundColor: widget.value ? theme.primaryColor : null,
      textColor: theme.textButtonTheme.style?.textStyle?.resolve({
        WidgetState.selected,
      })?.color,
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
