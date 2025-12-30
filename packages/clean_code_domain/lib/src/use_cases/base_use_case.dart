abstract class BaseUseCaseSync<T> {
  T call();
}

abstract class BaseUseCaseSyncParam<T, U> {
  U call(T param);
}

abstract class BaseUseCaseAsync<T> {
  Future<T> call();
}

abstract class BaseUseCaseAsyncParam<T, U> {
  Future<U> call(T param);
}

abstract class BaseUseCaseParam {
  Map<String, dynamic> toMap();
}

abstract class BaseCrudUseCase<T> {
  Future<T> create(BaseUseCaseParam param);

  Future<void> delete(String objectId);

  Future<List<T>> list();

  Future<T> read(String objectId);

  Future<T> update(String objectId, {required BaseUseCaseParam param});
}
