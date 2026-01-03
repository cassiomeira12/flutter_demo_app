import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'about.dart';

class AboutBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AboutController>(
      AboutController(
        openWebUrlUseCase: AppBinding.find(),
        appReviewUseCase: AppBinding.find(),
      ),
    );
  }
}
