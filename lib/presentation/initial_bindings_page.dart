import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
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
    PerformanceMetricUseCase.call(
      name: 'initialize-dependencies-performance-tracking',
      builder: (_) => _initializeAppDependencies(),
    );
  }

  Future<void> _initializeAppDependencies() async {
    await AppBindings().dependencies().whenComplete(() {
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
