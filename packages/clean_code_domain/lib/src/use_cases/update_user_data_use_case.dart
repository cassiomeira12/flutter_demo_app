import 'package:clean_code_domain/clean_code_domain.dart';

abstract class UpdateUserDataUseCase {
  Future<UserEntity> call(UserEntity user);
}
