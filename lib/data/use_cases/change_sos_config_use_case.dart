import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class ChangeSOSConfigUseCaseImpl implements ChangeSOSConfigUseCase {
  final EmergencyService _service;
  final UserAuthStorageUseCase _authStorageUseCase;

  ChangeSOSConfigUseCaseImpl({
    required EmergencyService emergencyService,
    required UserAuthStorageUseCase userAuthStorageUseCase,
  }) : _service = emergencyService,
       _authStorageUseCase = userAuthStorageUseCase;

  @override
  Future<SosConfigModel> call({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  }) async {
    final sosConfig =
        await _service.changeSOSConfig(
              onlyPolice: onlyPolice,
              onlySafetyContacts: onlySafetyContacts,
            )
            as SosConfigModel;

    final user = AppBinding.find<UserEntity>();

    final UserEntity userUpdated = user.copyWith(sosConfig: sosConfig);

    _authStorageUseCase.saveUserData(userUpdated.toMap());

    AppBinding.replace<UserEntity>(userUpdated);

    return sosConfig;
  }
}
