import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:splash/src/presentation/splash/splash.dart';

class SplashPage extends AppView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      hideAppBar: true,
      body: const SplashContentWidget(),
    );
  }
}
