abstract class BaseCrudService<T>
    implements
        CreateService<T>,
        DeleteService<T>,
        ListService<T>,
        ReadService<T>,
        UpdateService<T> {}

abstract class CreateService<T> {
  Future<T> create(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

abstract class DeleteService<T> {
  Future<void> delete(String objectId) {
    throw UnimplementedError();
  }
}

abstract class ListService<T> {
  Future<List<T>> list() {
    throw UnimplementedError();
  }
}

abstract class ReadService<T> {
  Future<T> read(String objectId) {
    throw UnimplementedError();
  }
}

abstract class UpdateService<T> {
  Future<T> update(String objectId, {required Map<String, dynamic> data}) {
    throw UnimplementedError();
  }
}
