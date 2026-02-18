import 'package:core/core.dart';

class ForbiddenException extends BaseException {
  ForbiddenException({super.message = 'forbidden_access'});
}
