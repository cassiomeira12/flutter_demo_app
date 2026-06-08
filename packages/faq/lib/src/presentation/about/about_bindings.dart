import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/data/data.dart';
import 'package:faq/src/domain/domain.dart';
import 'package:faq/src/presentation/about/about.dart';

class AboutBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AppReviewService>(
      AppReviewServiceImpl(),
    );

    AppBinding.put<AppReviewUseCase>(
      AppReviewUseCaseImpl(
        appReviewService: AppBinding.find(),
      ),
    );

    AppBinding.put<AboutController>(
      AboutController(
        openWebUrlUseCase: AppBinding.find(),
        appReviewUseCase: AppBinding.find(),
      ),
    );
  }
}
