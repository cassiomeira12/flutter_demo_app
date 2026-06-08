// ignore_for_file: must_be_immutable

import 'dart:developer' as developer;

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
  late ValueNotifier<bool> currentStateValue;

  @override
  void initState() {
    super.initState();
    currentStateValue = ValueNotifier<bool>(widget.value);
    currentStateValue.addListener(_onUpdateValue);
  }

  void _onUpdateValue() {
    widget.value = currentStateValue.value;
  }

  @override
  void dispose() {
    currentStateValue.removeListener(_onUpdateValue);
    currentStateValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    developer.log('ToggleButton ${widget.text}', name: 'Rebuild');
    return ValueListenableBuilder(
      valueListenable: currentStateValue,
      builder: (context, value, child) {
        return SecondaryButton(
          text: widget.text,
          borderColor: value ? theme.primaryColor : null,
          backgroundColor: value ? theme.primaryColor : null,
          textColor: theme.textButtonTheme.style?.textStyle?.resolve({
            WidgetState.selected,
          })?.color,
          expandWidth: widget.expandWidth,
          size: widget.size,
          onPressed: () {
            HapticFeedback.lightImpact();
            final oldValue = currentStateValue.value;
            currentStateValue.value = !oldValue;
            widget.onPressed.call(oldValue);
          },
        );
      },
    );
  }
}
