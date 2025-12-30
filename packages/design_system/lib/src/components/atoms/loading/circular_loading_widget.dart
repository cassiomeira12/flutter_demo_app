import 'package:dependency/dependency.dart';

class CircularLoadingWidget extends StatelessWidget {
  final Color? color;

  const CircularLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
    );
  }
}
