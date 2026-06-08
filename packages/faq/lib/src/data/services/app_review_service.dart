import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';

class AppReviewServiceImpl implements AppReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

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
