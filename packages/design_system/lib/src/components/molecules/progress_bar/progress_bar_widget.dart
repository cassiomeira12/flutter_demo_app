import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ProgressBarWidget extends StatelessWidget {
  final int currentIndex;
  final double percentage;
  final Color? color;

  const ProgressBarWidget({
    super.key,
    this.currentIndex = 0,
    this.percentage = 10,
    this.color,
  }) : assert(currentIndex >= 0, 'currentIndex must be greather than 0'),
       assert(percentage >= 0, 'percentage must be greather than 0');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: 3,
          alignment: Alignment.center,
          color: AppColors.scaffoldBackgroundDark,
          child: Row(
            children: [
              Container(
                width: (percentage / 100) * constraints.maxWidth,
                height: 3,
                color: SemanticColors.positive700,
              ),
            ],
          ),
        );
      },
    );
  }
}
