import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final containerHeight = ResponsiveSizeHelper.height(250);
        final containerWidth = constraints.maxWidth * .9;
        return ColoredBox(
          color:
              theme.bottomNavigationBarTheme.backgroundColor ??
              theme.scaffoldBackgroundColor,
          child: Skeletonizer(
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TextWidget('-------------------'),
                  const SpacerWidget(),
                  const TextWidget('-----------------------------'),
                  const SpacerWidget(),
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    color: theme.scaffoldBackgroundColor,
                  ),
                  const SpacerWidget(),
                  const TextWidget('-------------------'),
                  const SpacerWidget(),
                  const TextWidget('-----------------------------'),
                  const TextWidget('-------------------'),
                  const SpacerWidget(),
                  const TextWidget('-----------------------------'),
                  const TextWidget('-------------------'),
                  const SpacerWidget(),
                  const TextWidget('-----------------------------'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
