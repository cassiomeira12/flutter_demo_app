import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'unknown.dart';

class UnknownBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UnknownController>(UnknownController());
  }
}
