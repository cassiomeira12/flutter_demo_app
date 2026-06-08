import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:faq/src/domain/domain.dart';

class FeedbackController extends BaseController
    with NameValidator, EmailValidator {
  final SendUserFeedbackUseCase _sendUserFeedbackUseCase;

  FeedbackController({
    required this._sendUserFeedbackUseCase,
  });

  String? feedbackValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'feedback_input_empty_error'.tr;
    }
    return null;
  }

  Future<void> sendFeedback({
    required String name,
    required String email,
    required String feedback,
  }) async {
    try {
      final param = UserFeedbackEntity(
        name: name,
        email: email,
        feedback: feedback,
      );
      return await _sendUserFeedbackUseCase.call(param);
    } on BaseException catch (error) {
      Log.exception(error, null);
      rethrow;
    }
  }
}
