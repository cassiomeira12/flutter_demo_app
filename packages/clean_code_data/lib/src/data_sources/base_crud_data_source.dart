abstract class BaseCrudDataSource
    implements
        CreateDataSource,
        DeleteDataSource,
        ListDataSource,
        ReadDataSource,
        UpdateDataSource {}

abstract class CreateDataSource {
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

abstract class DeleteDataSource {
  Future<void> delete(String objectId) {
    throw UnimplementedError();
  }
}

abstract class ListDataSource {
  Future<List<Map<String, dynamic>>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) {
    throw UnimplementedError();
  }
}

abstract class ReadDataSource {
  Future<Map<String, dynamic>> read(String objectId) {
    throw UnimplementedError();
  }
}

abstract class UpdateDataSource {
  Future<Map<String, dynamic>> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) {
    throw UnimplementedError();
  }
}
