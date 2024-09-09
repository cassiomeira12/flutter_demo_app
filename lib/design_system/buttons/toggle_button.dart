// // ignore: must_be_immutable

// // ignore: must_be_immutable
// import 'package:flutter/material.dart';

// import '../icons/app_icons.dart';

// class ToggleButton extends StatefulWidget {
//   final String text;
//   final ValueChanged<bool>? onPressed;
//   bool? fullWidth;
//   AppIcons? icon;

//   ToggleButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.fullWidth = true,
//     this.icon,
//   });

//   @override
//   State<ToggleButton> createState() => _ToggleButtonState();
// }

// class _ToggleButtonState extends State<ToggleButton> {
//   bool isSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return SecondaryButton(
//       text: widget.text,
//       fullWidth: widget.fullWidth,
//       icon: widget.icon,
//       borderColor: isSelected ? AppColors.secondary : AppColors.neutral,
//       backgroundColor: isSelected ? AppColors.secondary : null,
//       textColor: isSelected ? AppColors.white : AppColors.neutralDark,
//       iconColor: isSelected ? AppColors.white : AppColors.neutralDark,
//       onPressed: () {
//         setState(() => isSelected = !isSelected);
//         widget.onPressed?.call(isSelected);
//       },
//     );
//   }
// }
