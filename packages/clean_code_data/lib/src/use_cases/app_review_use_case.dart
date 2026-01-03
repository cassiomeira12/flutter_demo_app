import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppReviewUseCaseImpl implements AppReviewUseCase {
  final _inAppReview = InAppReview.instance;

  @override
  Future<bool> isAvailable() async {
    return _inAppReview.isAvailable();
  }

  @override
  Future<void> requestReview() async {
    if (await isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
}
