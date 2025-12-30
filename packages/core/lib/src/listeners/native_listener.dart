import 'package:core/core.dart';

abstract class NativeListener {
  NativeMethodEnum get method;

  Future<void> call(dynamic arguments);
}
