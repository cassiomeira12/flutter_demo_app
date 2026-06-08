import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class UnknownBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UnknownController>(UnknownController());
  }
}
