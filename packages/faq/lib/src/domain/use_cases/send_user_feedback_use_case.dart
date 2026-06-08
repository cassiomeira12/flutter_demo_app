import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:faq/src/domain/domain.dart';

abstract class SendUserFeedbackUseCase
    extends BaseUseCaseAsyncParam<void, UserFeedbackEntity> {}

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
