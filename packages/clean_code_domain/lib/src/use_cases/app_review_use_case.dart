abstract class AppReviewUseCase {
  Future<bool> isAvailable();

  Future<void> requestReview();
}
