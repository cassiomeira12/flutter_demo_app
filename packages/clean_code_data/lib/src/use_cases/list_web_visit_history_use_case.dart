import 'package:clean_code_domain/clean_code_domain.dart';

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
