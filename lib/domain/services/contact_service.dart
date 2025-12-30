import 'package:flutter_demo_app/domain/domain.dart';

abstract class ContactService {
  Future<LocalContactEntity> getContact();
}
