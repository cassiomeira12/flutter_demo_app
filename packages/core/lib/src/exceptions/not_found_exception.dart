import 'package:core/core.dart';

class NotFoundException extends BaseException {
  NotFoundException({super.message = 'content_not_found'});
}
