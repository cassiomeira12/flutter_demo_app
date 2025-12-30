import 'package:core/core.dart';

abstract class ChangeSOSConfigUseCase {
  Future<SosConfigEntity> call({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  });
}
