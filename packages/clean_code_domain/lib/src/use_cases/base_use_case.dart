import 'package:clean_code_domain/clean_code_domain.dart';

abstract class UseCase {}

abstract class BaseUseCaseSync<R> extends UseCase {
  R call();
}

abstract class BaseUseCaseSyncParam<R, P> extends UseCase {
  R call(P param);
}

abstract class BaseUseCaseAsync<R> extends UseCase {
  Future<R> call();
}

abstract class BaseUseCaseAsyncParam<R, P> extends UseCase {
  Future<R> call(P param);
}

abstract class BaseUseCaseParam extends ParserToJson {}

abstract class BaseCrudUseCase<R> extends UseCase {
  Future<R> create(BaseUseCaseParam param);

  Future<void> delete(String id);

  Future<List<R>> list();

  Future<R> read(String id);

  Future<R> update(String id, {required BaseUseCaseParam param});
}
