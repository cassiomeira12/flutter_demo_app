import 'package:flutter/material.dart';

import 'responsive_size_helper.dart';

class Spacer extends StatelessWidget {
  final double width;
  final double height;

  const Spacer({
    super.key,
    this.width = 1,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSizeHelper.width(width * 12),
      height: ResponsiveSizeHelper.height(height * 12),
    );
  }
}
