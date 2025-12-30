import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ProgressBarWidget extends StatelessWidget {
  final int currentIndex;
  final double percentage;
  final Color? color;

  final int segments;

  const ProgressBarWidget({
    super.key,
    this.currentIndex = 0,
    this.percentage = 10,
    this.segments = 7,
    this.color,
  }) : assert(currentIndex >= 0, 'currentIndex must be greather than 0'),
       assert(percentage >= 0, 'percentage must be greather than 0'),
       assert(segments > 0, 'segments must be greather than 0');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(segments, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width:
                      (constraints.maxWidth / segments) -
                      .01 * constraints.maxWidth,
                  // height: index > currentIndex
                  //     ? constraints.maxHeight
                  //     : constraints.maxHeight,
                  height: 3,
                  alignment: Alignment.center,
                  color: index > currentIndex
                      ? SemanticColors.positive700
                      : AppColors.scaffoldBackgroundDark,
                  child: Row(
                    children: [
                      Container(
                        width: index > currentIndex
                            ? 0
                            : index < currentIndex
                            ? (constraints.maxWidth / segments) -
                                  .01 * constraints.maxWidth
                            : (percentage / 100) *
                                  ((constraints.maxWidth / segments) -
                                      .01 * constraints.maxWidth),
                        // height: index > currentIndex
                        //     ? constraints.maxHeight
                        //     : constraints.maxHeight,
                        height: 3,
                        color: AppColors.statusWarning,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
