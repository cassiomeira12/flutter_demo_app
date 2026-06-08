import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class AppView<T extends BaseController> extends GetView<T> {
  const AppView({super.key});

  @override
  T get controller => AppBinding.find<T>(tag: tag);
}
