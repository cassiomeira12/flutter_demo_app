import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../text/text_style.dart';
import '../text/text_widget.dart';
import 'button_size.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppColor? textColor;
  final AppColor? color;
  final bool expandWidth;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    this.text,
    this.textColor,
    this.icon,
    this.onPressed,
    this.color,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            onPressed == null
                ? AppColors.secondary
                : color ?? Theme.of(context).cardColor,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisSize: expandWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: icon == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: icon,
                ),
              TextWidget(
                text ?? '',
                style: AppTextStyle.button(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
