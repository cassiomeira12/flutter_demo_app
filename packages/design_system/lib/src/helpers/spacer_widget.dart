import 'package:dependency/dependency.dart';
import 'package:design_system/src/helpers/helpers.dart';

class SpacerWidget extends StatelessWidget {
  final double width;
  final double height;

  const SpacerWidget({super.key, this.width = 1, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSizeHelper.width(width * 12),
      height: ResponsiveSizeHelper.height(height * 12),
    );
  }
}
