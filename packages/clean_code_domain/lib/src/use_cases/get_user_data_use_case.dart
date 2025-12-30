import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetUserDataUseCase {
  Future<UserEntity> call();
}
