// ignore_for_file: must_be_immutable

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'admin_crud_details_page.dart';

class AdminCrudListController<T> extends ListenableBaseController<T> {
  final Future<List<T>> Function() _fetchDataFunction;

  AdminCrudListController({required Future<List<T>> Function() onFetch})
    : _fetchDataFunction = onFetch;

  @override
  Future<List<T>> Function() get fetchDataFunction => _fetchDataFunction;

  @override
  String get pageRouteNamed => '/AdminCrudListPage';
}

class AdminCrudListPage<T> extends AppView<AdminCrudListController<T>> {
  final String title;
  final T Function(Map<String, dynamic> map) fromMapBuilder;
  final Map<String, dynamic> Function(T item) toMapBuilder;
  final List<Map<String, dynamic>> inputFields;

  Future<T> Function(Map<String, dynamic> map) createDataFunction;
  Future<void> Function(String objectId) deleteDataFunction;
  final Future<List<T>> Function() listDataFunction;
  Future<T> Function(Map<String, dynamic> map) updateDataFunction;

  late AdminCrudListController<T> _controller;

  @override
  AdminCrudListController<T> get controller => _controller;

  AdminCrudListPage({
    super.key,
    required this.title,
    required this.fromMapBuilder,
    required this.toMapBuilder,
    required this.inputFields,
    required this.createDataFunction,
    required this.deleteDataFunction,
    required this.listDataFunction,
    required this.updateDataFunction,
  }) {
    _controller = AdminCrudListController<T>(onFetch: listDataFunction);
    _controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: title,
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          key: const Key('web_visit_history_update_popup_menu_item_key'),
          value: 'update'.tr,
          onTap: controller.onFetchListData,
          child: TextWidget('update'.tr),
        ),
      ],
      body: ScrollStateWidget<T>(
        list: controller.list,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.onFetchListData,
        emptyMessage: 'empty_web_visit_history_list'.tr,
        fromMapBuilder: fromMapBuilder,
        toMapBuilder: toMapBuilder,
        builder: (context, index, item) {
          return ListTile(
            key: Key('list_item_index_${index}_key'),
            title: TextWidget(item.toString()),
            onTap: () async {
              final result = await AppNavigator.to(
                () => AdminCrudDetailsPage(
                  inputFields: inputFields,
                  itemData: toMapBuilder.call(item),
                  onSave: updateDataFunction,
                  autoCompleteSearchItems: () async {
                    final list = await listDataFunction();
                    return list.map((item) {
                      return AutoCompleteItem(item.toString(), item);
                    }).toList();
                  },
                ),
              );
              if (result == true) {
                controller.onFetchListData();
              }
            },
            trailing: IconButtonWidget(
              icon: FlutterIcon(
                Icons.delete,
                color: Theme.of(context).popupMenuTheme.iconColor,
              ),
              onPressed: () async {
                final bool? result = await DialogWidget.showChoice(
                  context,
                  title: 'delete'.tr,
                  message: 'deseja apagar o item selecionado?'.tr,
                  okButton: 'delete'.tr,
                );
                if (result == true) {
                  final String objectId = toMapBuilder.call(item)['objectId'];
                  await deleteDataFunction(objectId);
                  controller.onFetchListData();
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return FloatingButtonWidget(
          key: const Key('add_new_transaction_key'),
          icon: FlutterIcon(
            Icons.add,
            color: Theme.of(context).popupMenuTheme.iconColor,
          ),
          onPressed: () async {
            final result = await AppNavigator.to(
              () => AdminCrudDetailsPage(
                inputFields: inputFields,
                itemData: null,
                onSave: createDataFunction,
              ),
            );
            if (result == true) {
              controller.onFetchListData();
            }
          },
        );
      }),
    );
  }
}
