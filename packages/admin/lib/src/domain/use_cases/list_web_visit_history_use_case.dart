import 'package:admin/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListWebVisitHistoryUseCase
    extends BaseUseCaseAsync<List<WebVisitHistoryEntity>> {}

class ListWebVisitHistoryUseCaseImpl implements ListWebVisitHistoryUseCase {
  final WebVisitHistoryService _service;

  ListWebVisitHistoryUseCaseImpl({
    required WebVisitHistoryService webVisitHistoryService,
  }) : _service = webVisitHistoryService;

  @override
  Future<List<WebVisitHistoryEntity>> call() {
    return _service.list();
  }
}
