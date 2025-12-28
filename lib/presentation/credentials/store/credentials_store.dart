import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CredentialsStore {
  Rxn<CredentialEntity> credential = Rxn();
  RxList<CredentialEntity> credentials = RxList.empty();

  int? get selectedIndex {
    return credentials.indexWhere((item) {
      return credential.value?.name == item.name;
    });
  }
}
