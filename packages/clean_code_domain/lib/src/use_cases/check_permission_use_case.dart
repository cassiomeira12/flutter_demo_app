import 'package:dependency/dependency.dart';

abstract class CheckPermissionUseCase {
  Future<PermissionStatus> call(Permission permission);
}
