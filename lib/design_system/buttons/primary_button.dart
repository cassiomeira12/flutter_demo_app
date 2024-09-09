import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../text/text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppColor? textColor;
  final AppColor? color;

  const PrimaryButton({
    super.key,
    this.text,
    this.textColor,
    this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<AppColor>(
          onPressed == null
              ? AppColors.secondary
              : color ?? AppColors.secondary,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 32),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: icon,
              ),
            Text(
              text ?? '',
              style: AppTextStyle.button(
                context,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
