import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';

abstract class AppReviewUseCase extends UseCase {
  Future<bool> isAvailable();

  Future<void> requestReview();
}

class AppReviewUseCaseImpl implements AppReviewUseCase {
  final AppReviewService _appReviewService;

  AppReviewUseCaseImpl({required this._appReviewService});

  @override
  Future<bool> isAvailable() {
    return _appReviewService.isAvailable();
  }

  @override
  Future<void> requestReview() {
    return _appReviewService.requestReview();
  }
}
