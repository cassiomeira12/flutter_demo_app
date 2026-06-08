import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';

class CircularLoadingWidget extends StatelessWidget {
  final Color? color;

  const CircularLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    developer.log('CircularLoadingWidget', name: 'Rebuild');
    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
    );
  }
}
