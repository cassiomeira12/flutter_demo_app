import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/contacts/contacts_controller.dart';
import 'package:flutter_demo_app/presentation/contacts/widgets/safety_contact_widget.dart';

class ContactsPage extends AppView<ContactsController> {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'contacts'.tr,
      showNotificationsIcon: true,
      body: ScrollStateWidget<SafetyContactEntity>(
        list: controller.list,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.listAllSafetyContacts,
        emptyMessage: 'empty_contacts_list'.tr,
        fromMapBuilder: (map) {
          return SafetyContactModel.fromMap(map).copyWith();
        },
        toMapBuilder: (item) => item.toMap(),
        builder: (context, index, item) {
          return SafetyContactWidget(
            key: Key('safety_contact_item_index_${index}_key'),
            safetyContactEntity: item,
            onDelete: controller.deleteSafetyContact,
          );
        },
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: controller.newContact,
        icon: FlutterIcon(
          key: const Key('new_contact_button_key'),
          Icons.add,
          color: Theme.of(context).popupMenuTheme.iconColor,
        ),
      ),
    );
  }
}
