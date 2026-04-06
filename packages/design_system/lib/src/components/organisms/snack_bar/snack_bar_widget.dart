import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class SnackBarWidget {
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    Duration? duration,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final buttonBackgroundColor = theme.textButtonTheme.style?.backgroundColor
        ?.resolve({
          WidgetState.selected,
        });
    final textColor = theme.textButtonTheme.style?.textStyle?.resolve({
      WidgetState.selected,
    })?.color;
    final snackBar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
            title,
            style: AppTextStyle.subtitle(
              context,
              fontSize: TextSize.font_14,
            ),
          ),
          if (message != null) TextWidget(message),
        ],
      ),
      action: duration == null
          ? SnackBarAction(
              label: 'ok'.tr,
              backgroundColor: buttonBackgroundColor,
              textColor: textColor,
              onPressed: () {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
