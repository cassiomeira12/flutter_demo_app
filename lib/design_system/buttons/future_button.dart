import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../text/text_style.dart';
import '../text/text_widget.dart';
import 'button_size.dart';

class FutureButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final AppColor? backgroundColor;
  final AppColor? textColor;
  final ButtonSize size;

  const FutureButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.size = ButtonSize.large,
  });

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: ElevatedButton(
        onPressed: widget.onPressed != null
            ? () async {
                if (!loading) {
                  setState(() => loading = true);
                  try {
                    await widget.onPressed?.call();
                  } finally {
                    setState(() => loading = false);
                  }
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  )
                : TextWidget(
                    widget.text,
                    style: AppTextStyle.button(context),
                  ),
          ],
        ),
      ),
    );
  }
}
