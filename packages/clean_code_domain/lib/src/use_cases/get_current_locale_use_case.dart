import 'package:dependency/dependency.dart';

abstract class GetCurrentLocaleUseCase {
  Future<Locale?> call();
}
