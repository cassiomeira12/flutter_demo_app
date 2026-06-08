import 'package:clean_code_data/clean_code_data.dart';
import 'package:faq/src/domain/domain.dart';

class UserFeedbackRepositoryImpl extends BaseRepositoryImpl<UserFeedbackEntity>
    implements UserFeedbackRepository {
  UserFeedbackRepositoryImpl({
    super.localDatabaseName = 'user_feedback',
    required UserFeedbackService super.service,
    required super.checkInternetUseCase,
    required super.localStorageUseCase,
    required super.localDatabase,
  });
}
