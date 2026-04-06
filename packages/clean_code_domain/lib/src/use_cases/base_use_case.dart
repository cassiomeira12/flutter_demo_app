abstract class BaseUseCaseSync<R> {
  R call();
}

abstract class BaseUseCaseSyncParam<R, P> {
  R call(P param);
}

abstract class BaseUseCaseAsync<R> {
  Future<R> call();
}

abstract class BaseUseCaseAsyncParam<R, P> {
  Future<R> call(P param);
}

abstract class BaseUseCaseParam {
  Map<String, dynamic> toMap();
}

abstract class BaseCrudUseCase<R> {
  Future<R> create(BaseUseCaseParam param);

  Future<void> delete(String id);

  Future<List<R>> list();

  Future<R> read(String id);

  Future<R> update(String id, {required BaseUseCaseParam param});
}
