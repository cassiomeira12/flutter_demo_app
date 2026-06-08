import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class ChangeSOSConfigUseCase extends UseCase {
  Future<SosConfigEntity> call({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  });
}

class ChangeSOSConfigUseCaseImpl implements ChangeSOSConfigUseCase {
  final EmergencyService _emergencyService;
  final UserAuthStorageUseCase _userAuthStorageUseCase;

  ChangeSOSConfigUseCaseImpl({
    required this._emergencyService,
    required this._userAuthStorageUseCase,
  });

  @override
  Future<SosConfigEntity> call({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  }) async {
    final sosConfig = await _emergencyService.changeSOSConfig(
      onlyPolice: onlyPolice,
      onlySafetyContacts: onlySafetyContacts,
    );

    final user = AppBinding.find<UserEntity>();

    final UserEntity userUpdated = user.copyWith(sosConfig: sosConfig);

    AppBinding.replace<UserEntity>(userUpdated);

    _userAuthStorageUseCase.saveUserData(userUpdated);

    return sosConfig;
  }
}
