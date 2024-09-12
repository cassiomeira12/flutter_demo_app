// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../icons/app_icons.dart';
import '../text/text_style.dart';
import '../text/text_widget.dart';
import 'button_size.dart';

class SecondaryButton extends StatelessWidget {
  final String? text;
  final AppIcon? icon;
  final VoidCallback? onPressed;
  final AppColor? textColor;
  final AppColor? borderColor;
  final AppColor? backgroundColor;
  final ButtonSize size;

  SecondaryButton({
    super.key,
    this.text,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor ?? Theme.of(context).hintColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
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
    );
  }
}
