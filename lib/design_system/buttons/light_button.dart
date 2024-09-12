import 'package:flutter/material.dart';

import '../text/text_style.dart';
import '../text/text_widget.dart';

class LightButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const LightButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: OutlinedButton.styleFrom(
        // backgroundColor: backgroundColor,
        // side: BorderSide(
        //   color: borderColor ?? AppColors.neutral,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: TextWidget(
        text,
        style: AppTextStyle.button(context),
      ),
      onPressed: onPressed,
    );
  }
}
