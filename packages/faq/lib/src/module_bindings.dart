import 'package:core/core.dart';
import 'package:faq/src/data/data.dart';
import 'package:faq/src/domain/domain.dart';

class FaqModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<UserFeedbackService>(
      SentryUserFeedbackServiceImpl(),
      permanent: true,
    );

    final repository = AppBinding.put<UserFeedbackRepository>(
      UserFeedbackRepositoryImpl(
        service: AppBinding.find(),
        checkInternetUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        localDatabase: AppBinding.find(),
      ),
      permanent: true,
    );

    await repository.initLocalDatabase();
  }
}
