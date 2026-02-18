import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

class WebVisitHistoryServiceImpl
    with ListServiceMixin<WebVisitHistoryEntity>
    implements WebVisitHistoryService {
  final WebVisitHistoryDataSource _dataSource;

  WebVisitHistoryServiceImpl({
    required WebVisitHistoryDataSource webVisitHistoryDataSource,
  }) : _dataSource = webVisitHistoryDataSource;

  @override
  Future<List<WebVisitHistoryEntity>> list() {
    return mixinList(
      list: _dataSource.list,
      fromMap: WebVisitHistoryModel.fromMap,
    );
  }
}
