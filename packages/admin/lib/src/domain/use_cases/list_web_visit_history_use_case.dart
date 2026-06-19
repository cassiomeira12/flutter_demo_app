import 'package:admin/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListWebVisitHistoryUseCase
    extends BaseUseCaseAsync<List<WebVisitHistoryEntity>> {}

class ListWebVisitHistoryUseCaseImpl implements ListWebVisitHistoryUseCase {
  final WebVisitHistoryService _webVisitHistoryService;

  ListWebVisitHistoryUseCaseImpl({required this._webVisitHistoryService});

  @override
  Future<List<WebVisitHistoryEntity>> call() {
    return _webVisitHistoryService.list();
  }
}
