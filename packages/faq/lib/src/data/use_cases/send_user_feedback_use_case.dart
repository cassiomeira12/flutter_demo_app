import 'package:faq/src/domain/domain.dart';

class SendUserFeedbackUseCaseImpl implements SendUserFeedbackUseCase {
  final UserFeedbackRepository _repository;

  SendUserFeedbackUseCaseImpl({
    required UserFeedbackRepository userFeedbackRepository,
  }) : _repository = userFeedbackRepository;

  @override
  Future<void> call(UserFeedbackEntity param) {
    return _repository.create(param.toMap());
  }
}
