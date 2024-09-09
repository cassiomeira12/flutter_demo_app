// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../icons/app_icons.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  bool? fullWidth;
  AppColor? borderColor;
  AppColor? backgroundColor;
  TextStyle? style;
  AppColor? textColor;
  AppIcons? icon;
  AppColor? iconColor;

  SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fullWidth = true,
    this.borderColor,
    this.backgroundColor,
    this.style,
    this.textColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor ?? AppColors.neutral,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppIcon(
                icon!,
                color: iconColor ?? AppColors.neutral,
              ),
            ),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // style: AppTextStyle.button(
            //   context,
            //   color: textColor,
            // ),
          ),
        ],
      ),
    );
  }
}
