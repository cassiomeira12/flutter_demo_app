import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UpdateUserLocaleUseCaseImpl implements UpdateUserLocaleUseCase {
  final UserAuthStorageUseCase _authStorageUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final GetDeviceLocaleUseCase _getDeviceLocaleUseCase;
  final UpdateLocaleUseCase _updateLocaleUseCase;

  UpdateUserLocaleUseCaseImpl({
    required UserAuthStorageUseCase authStorageUseCase,
    required UpdateUserDataUseCase updateUserDataUseCase,
    required GetDeviceLocaleUseCase getDeviceLocaleUseCase,
    required UpdateLocaleUseCase updateLocaleUseCase,
  }) : _authStorageUseCase = authStorageUseCase,
       _updateUserDataUseCase = updateUserDataUseCase,
       _getDeviceLocaleUseCase = getDeviceLocaleUseCase,
       _updateLocaleUseCase = updateLocaleUseCase;

  @override
  Future<void> call(UserEntity user, {Locale? definedLocale}) async {
    if (definedLocale != null) {
      final userUpdated = user.copyWith(locale: definedLocale.toString());
      await _updateUserDataUseCase.call(userUpdated);
      await _authStorageUseCase.saveUserData(userUpdated.toMap());
      await AppBinding.replace<UserEntity>(userUpdated);
      await _updateLocaleUseCase.call(definedLocale);
      return;
    }

    final Locale deviceLocale = await _getDeviceLocaleUseCase.call();

    if (user.locale != null) {
      if (user.locale != deviceLocale.toString()) {
        final List<String> split = user.locale!.split('_');
        final String languageCode = split.first;
        final String? countryCode = split.length > 1 ? split.last : null;
        final locale = Locale(languageCode, countryCode);
        await _updateLocaleUseCase.call(locale);
      }
      return;
    }

    final userUpdated = user.copyWith(locale: deviceLocale.toString());
    await _updateUserDataUseCase.call(userUpdated);
    await _authStorageUseCase.saveUserData(userUpdated.toMap());
    await AppBinding.replace<UserEntity>(userUpdated);
  }
}
