import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/app/app_bindings.dart';

class InitialBindingsPage extends StatefulWidget {
  const InitialBindingsPage({super.key});

  @override
  State<InitialBindingsPage> createState() => _InitialBindingsPageState();
}

class _InitialBindingsPageState extends State<InitialBindingsPage> {
  @override
  void initState() {
    super.initState();
    AppBindings().dependencies().whenComplete(() {
      AppNavigator.toNamed(AppRouter.splash);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: null,
      hideAppBar: true,
      body: const SplashContentWidget(),
    );
  }
}
