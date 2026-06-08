import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class ContactsController extends BaseController {
  final ListSafetyContactUseCase _listSafetyContactUseCase;
  final DeleteSafetyContactUseCase _deleteSafetyContactUseCase;

  ContactsController({
    required this._listSafetyContactUseCase,
    required this._deleteSafetyContactUseCase,
  });

  RxList<SafetyContactEntity> list = RxList.empty();
  RxBool isLoading = RxBool(true);
  RxString errorMessage = RxString('');

  @override
  String get pageRouteNamed => AppRouter.contacts.name;

  @override
  void onReady() {
    super.onReady();
    listAllSafetyContacts();
  }

  Future<void> listAllSafetyContacts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _listSafetyContactUseCase.call(0);
      list.value = result;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSafetyContact(String objectId) async {
    clickTagging(component: 'remove_safety_contact_${objectId}_key');
    await _deleteSafetyContactUseCase.call(objectId);
    final List<SafetyContactEntity> temp = List.from(list);
    temp.removeWhere((item) => item.objectId == objectId);
    list.value = temp;
  }

  Future<void> newContact() async {
    clickTagging(component: 'new_contact_button_key');
    final result = await AppNavigator.toNamed(AppRouter.newContact);
    if (result == true) {
      listAllSafetyContacts();
    }
  }
}
