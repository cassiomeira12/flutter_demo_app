import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class ContactServiceImpl implements ContactService {
  @override
  Future<LocalContactEntity> getContact() async {
    try {
      final Contact? contact = await FlutterContacts.openExternalPick();
      if (contact == null) throw BaseException();

      String phone = contact.phones.first.number;
      if (phone.length >= 10) {
        if (phone.length > 11) {
          phone = phone.substring(3);
        }
      }
      return LocalContactEntity(
        name: contact.displayName,
        phoneNumber: phone,
      );
    } on BaseException {
      rethrow;
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }
}
