import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SplashContentWidget extends StatelessWidget {
  const SplashContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).primaryColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Center(
                child: Container(
                  width: ResponsiveSizeHelper.width(150),
                  height: ResponsiveSizeHelper.width(150),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(AppAssets.logo)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * .5),
                child: const Center(child: CircularLoadingWidget()),
              ),
            ],
          );
        },
      ),
    );
  }
}
