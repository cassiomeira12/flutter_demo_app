import 'package:dependency/dependency.dart';

abstract class GetDeviceLocaleUseCase {
  Future<Locale> call();
}
