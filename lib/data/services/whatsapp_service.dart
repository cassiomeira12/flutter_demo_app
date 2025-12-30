import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class WhatsAppServiceImpl implements WhatsAppService {
  final WhatsAppDataSource _dataSource;

  WhatsAppServiceImpl({
    required WhatsAppDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<void> sendWhatsAppCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      return await _dataSource.sendWhatsAppCode(
        phoneNumber: phoneNumber,
        code: code,
      );
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
