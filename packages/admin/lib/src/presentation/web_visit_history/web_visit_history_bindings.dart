import 'package:admin/src/data/data.dart';
import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/infra/infra.dart';
import 'package:admin/src/presentation/web_visit_history/web_visit_history.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebVisitHistoryBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<WebVisitHistoryDataSource>(
      WebVisitHistoryDataSourceImpl(
        http: AppBinding.find(),
      ),
    );

    AppBinding.put<WebVisitHistoryService>(
      WebVisitHistoryServiceImpl(
        webVisitHistoryDataSource: AppBinding.find(),
      ),
    );

    AppBinding.put<ListWebVisitHistoryUseCase>(
      ListWebVisitHistoryUseCaseImpl(
        webVisitHistoryService: AppBinding.find(),
      ),
    );

    AppBinding.put<WebVisitHistoryController>(
      WebVisitHistoryController(
        listWebVisitHistoryUseCase: AppBinding.find(),
      ),
    );
  }
}
