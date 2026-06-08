abstract class AppReviewService {
  Future<bool> isAvailable();

  Future<void> requestReview();
}
