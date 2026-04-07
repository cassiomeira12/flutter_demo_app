import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CredentialServiceImpl extends BaseCrudServiceMixin<CredentialEntity>
    implements CredentialService {
  final CredentialDataSource _dataSource;

  CredentialServiceImpl({
    required CredentialDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  CredentialEntity parseMap(Map<String, dynamic> map) {
    return CredentialModel.fromMap(map);
  }

  @override
  Future<CredentialEntity> create(Map<String, dynamic> data) {
    return mixinCreate(
      data: data,
      create: _dataSource.create,
      fromMap: parseMap,
    );
  }

  @override
  Future<void> delete(String objectId) {
    return mixinDelete(
      objectId: objectId,
      delete: _dataSource.delete,
    );
  }

  @override
  Future<List<CredentialEntity>> list({
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
      fromMap: parseMap,
    );
  }

  @override
  Future<CredentialEntity> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) {
    return mixinUpdate(
      objectId: objectId,
      data: data,
      update: _dataSource.update,
      fromMap: parseMap,
    );
  }

  @override
  Future<CredentialEntity> read(String objectId) {
    throw UnimplementedError();
  }
}
