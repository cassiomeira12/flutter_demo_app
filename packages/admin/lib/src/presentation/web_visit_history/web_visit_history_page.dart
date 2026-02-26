import 'package:admin/src/presentation/web_visit_history/web_visit_history.dart';
import 'package:admin/src/presentation/web_visit_history/widgets/widgets.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebVisitHistoryPage extends AppView<WebVisitHistoryController> {
  const WebVisitHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'web_visit_history'.tr,
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          key: const Key('web_visit_history_update_popup_menu_item_key'),
          value: 'update'.tr,
          onTap: controller.refreshWebVisitHistory,
          child: TextWidget('update'.tr),
        ),
      ],
      body: ScrollStateWidget<WebVisitHistoryEntity>(
        list: controller.list,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.onFetchListData,
        emptyMessage: 'empty_web_visit_history_list'.tr,
        fromMapBuilder: (map) {
          return WebVisitHistoryModel.fromMap(map);
        },
        toMapBuilder: (item) => item.toMap(),
        builder: (context, index, item) {
          return WebVisitHistoryWidget(
            key: Key('notification_item_index_${index}_key'),
            webVisitHistoryEntity: item,
            // notification: item,
            // onTap: () {
            //   controller.readNotification(item);
            // },
          );
        },
      ),
    );
  }
}
