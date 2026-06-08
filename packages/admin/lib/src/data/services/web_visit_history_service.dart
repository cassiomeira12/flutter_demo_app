import 'package:admin/src/data/data.dart';
import 'package:admin/src/domain/domain.dart';
import 'package:clean_code_data/clean_code_data.dart';

class WebVisitHistoryServiceImpl
    with ListServiceMixin<WebVisitHistoryEntity>
    implements WebVisitHistoryService {
  final WebVisitHistoryDataSource _dataSource;

  WebVisitHistoryServiceImpl({
    required WebVisitHistoryDataSource webVisitHistoryDataSource,
  }) : _dataSource = webVisitHistoryDataSource;

  @override
  Future<List<WebVisitHistoryEntity>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) {
    return mixinList(
      list: () => _dataSource.list(
        limit: limit,
        skip: skip,
        order: order,
        where: where,
      ),
      fromMap: WebVisitHistoryModel.fromMap,
    );
  }
}
