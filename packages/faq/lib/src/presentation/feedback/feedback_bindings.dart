import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';
import 'package:faq/src/presentation/feedback/feedback.dart';

class FeedbackBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SendUserFeedbackUseCase>(
      SendUserFeedbackUseCaseImpl(
        userFeedbackRepository: AppBinding.find(),
      ),
    );

    AppBinding.put<FeedbackController>(
      FeedbackController(
        sendUserFeedbackUseCase: AppBinding.find(),
      ),
    );
  }
}
