import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class UpdateUserLocaleUseCase extends UseCase {
  Future<void> call(UserEntity user, {Locale? definedLocale});
}

class UpdateUserLocaleUseCaseImpl implements UpdateUserLocaleUseCase {
  final UserAuthStorageUseCase _authStorageUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final GetDeviceLocaleUseCase _getDeviceLocaleUseCase;
  final UpdateLocaleUseCase _updateLocaleUseCase;

  UpdateUserLocaleUseCaseImpl({
    required this._authStorageUseCase,
    required this._updateUserDataUseCase,
    required this._getDeviceLocaleUseCase,
    required this._updateLocaleUseCase,
  });

  @override
  Future<void> call(UserEntity user, {Locale? definedLocale}) async {
    if (definedLocale != null) {
      final userUpdated = user.copyWith(locale: definedLocale.toString());
      await _updateUserDataUseCase.call(userUpdated);
      await _authStorageUseCase.saveUserData(userUpdated);
      Log.debug('Update to defined locale [$definedLocale]');
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
        Log.debug('Update to user locale [$locale]');
        await _updateLocaleUseCase.call(locale);
      }
      return;
    }

    final userUpdated = user.copyWith(locale: deviceLocale.toString());

    try {
      await _updateUserDataUseCase.call(userUpdated);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    } finally {
      await _authStorageUseCase.saveUserData(userUpdated);
    }
  }
}
