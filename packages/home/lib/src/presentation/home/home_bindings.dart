import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:home/src/presentation/home/home.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // AppBinding.put<NotificationsStore>(NotificationsStore());

    AppBinding.put<HomeController>(
      HomeController(checkInternetUseCase: AppBinding.find()),
    );
  }
}
