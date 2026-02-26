import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

enum KeyboardVisibilityState { visible, hidden }

class KeyboardVisibilityWidget extends StatefulWidget {
  final Widget child;
  final Function(KeyboardVisibilityState state) onKeyboardStateChange;

  const KeyboardVisibilityWidget({
    super.key,
    required this.child,
    required this.onKeyboardStateChange,
  });

  @override
  State<KeyboardVisibilityWidget> createState() =>
      _KeyboardVisibilityWidgetState();
}

class _KeyboardVisibilityWidgetState extends State<KeyboardVisibilityWidget>
    with WidgetsBindingObserver {
  late KeyboardVisibilityState state;

  @override
  void initState() {
    super.initState();
    state = currentState;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    checkState();
  }

  KeyboardVisibilityState get currentState {
    final newValue = ResponsiveSizeHelper.mediaQuery.viewInsets.bottom;
    return newValue != 0.0
        ? KeyboardVisibilityState.visible
        : KeyboardVisibilityState.hidden;
  }

  void checkState() {
    if (currentState != state) {
      state = currentState;
      widget.onKeyboardStateChange.call(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
