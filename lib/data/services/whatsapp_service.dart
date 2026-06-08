import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class WhatsAppServiceImpl implements WhatsAppService {
  final WhatsAppDataSource _whatsAppDataSource;

  WhatsAppServiceImpl({required this._whatsAppDataSource});

  @override
  Future<void> sendWhatsAppCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      return await _whatsAppDataSource.sendWhatsAppCode(
        phoneNumber: phoneNumber,
        code: code,
      );
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }
}
