import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class NewContactController extends BaseController {
  final CreateSafetyContactUseCase _createSafetyContactUseCase;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final GetLocalContactUseCase _getLocalContactUseCase;

  NewContactController({
    required CreateSafetyContactUseCase createSafetyContactUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    required GetLocalContactUseCase getLocalContactUseCase,
  }) : _createSafetyContactUseCase = createSafetyContactUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       _getLocalContactUseCase = getLocalContactUseCase;

  final nameTextController = TextEditingController();
  final intialPhoneNumber = RxString('');
  final phoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  final sendMessageToContact = RxBool(true);

  String phoneNumber = '';

  String? nameValidator(String? input) {
    if (input?.isEmpty ?? true) {
      return 'name_input_empty_error'.tr;
    }
    return null;
  }

  String? phoneNumberValidator(String? input) {
    if (input!.isEmpty) {
      return 'write_whatsapp_number'.tr;
    } else if (input.length < 14) {
      return 'write_whatsapp_correct_number'.tr;
    }
    return null;
  }

  Future<void> createSafetyContact({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  }) async {
    clickTagging(component: 'save_new_contact_button_key');
    await _createSafetyContactUseCase.call(
      name: name,
      phoneNumber: phoneNumber,
      sendMessage: sendMessage,
    );
  }

  Future<LocalContactEntity> getLocalContact() async {
    clickTagging(component: 'search_contacts_list_key');

    final PermissionStatus hasContactsPermission = await _checkPermissionUseCase
        .call(Permission.contacts);

    if (hasContactsPermission == PermissionStatus.granted) {
      // hasContactsPermission = await AppNavigator.to(
      //   () => const PermissionRequestWidget(
      //     permission: Permission.contacts,
      //   ),
      //   ignoreId: true,
      // );
      // if (hasContactsPermission?.isDenied ?? true) {
      //   throw BaseException(message: 'you_must_accept_contacts_permission');
      // }
    }

    final LocalContactEntity contact = await _getLocalContactUseCase.call();

    Log.debug(contact.toString());

    return contact;
  }
}
