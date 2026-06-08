// ignore_for_file: must_be_immutable

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AutoCompleteItem {
  final String name;
  final dynamic data;

  AutoCompleteItem(this.name, this.data);
}

class AdminCrudDetailsController extends BaseController {
  @override
  String get pageRouteNamed => '/AdminCrudDetailsPage';
}

class AdminCrudDetailsPage<T> extends AppView<AdminCrudDetailsController> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> controllersMap = {};

  late AdminCrudDetailsController _controller;

  @override
  AdminCrudDetailsController get controller => _controller;

  final List<Map<String, dynamic>> inputFields;
  final Map<String, dynamic>? itemData;
  final Future<T> Function(Map<String, dynamic> map) onSave;
  final Future<List<AutoCompleteItem>> Function()? autoCompleteSearchItems;

  List<Map<String, dynamic>> newInputFields = [];

  AdminCrudDetailsPage({
    super.key,
    required this.inputFields,
    required this.itemData,
    required this.onSave,
    this.autoCompleteSearchItems,
  }) {
    _controller = AdminCrudDetailsController();
    _controller.onInit();
    for (final input in inputFields) {
      if (input['enabled'] == false && input['readOnly'] == true) {
        if (itemData != null) {
          newInputFields.add(input);
          controllersMap[input['key']] = TextEditingController(
            text: input['initialValue'] ?? itemData?[input['result_name']],
          );
        }
      } else {
        newInputFields.add(input);
        controllersMap[input['key']] = TextEditingController(
          text: input['initialValue'] ?? itemData?[input['result_name']],
        );
      }
    }
  }

  final Map<String, dynamic> config2 = {
    'inputs': [
      {
        'type': 'TextFieldWidget',
        'key': 'category_input_key',
        'enabled': false,
        'readOnly': true,
        'label': 'category'.tr,
        'initialValue': 'ElaAxnG4UI',
        'hintText': 'enter_your_full_name'.tr,
        'keyboardType': TextInputType.name,
        'result_name': 'categoryId',
      },
      {
        'type': 'TextFieldWidget',
        'key': 'name_input_key',
        'label': 'name'.tr,
        'hintText': 'enter_your_full_name'.tr,
        'validator': 'NotEmptyValidator',
        'keyboardType': TextInputType.name,
        'result_name': 'name',
      },
    ],
    'mutationScheme': '''
      mutation {
        createTransactionSubCategory(
          input: {
            fields: {
              category: {
                link: "{categoryId}"
              }
              name: "{name}"
            }
          }
        ) {
          transactionSubCategory {
            objectId,
            category {
              objectId,
              name,
            }
            name,
          }
        }
      }
    ''',
  };

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '',
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                  children: [
                    ...List.from(newInputFields).map((fieldConfig) {
                      if (fieldConfig['type'] == 'TextFieldWidget') {
                        return TextFieldWidget(
                          key: Key(fieldConfig['key']),
                          enabled: fieldConfig['enabled'],
                          readOnly: fieldConfig['readOnly'],
                          enableClearTextSuffixIcon: true,
                          label: fieldConfig['label'],
                          hintText: fieldConfig['hintText'],
                          controller: controllersMap[fieldConfig['key']],
                          // validator: (String? input) {
                          //   return controller.getValidator(
                          //     input,
                          //     type: fieldConfig['validator'],
                          //   );
                          // },
                          keyboardType: fieldConfig['keyboardType'],
                          obscureText: fieldConfig['obscureText'] ?? false,
                        );
                      }
                      if (fieldConfig['type'] == 'AutoCompleteFieldWidget') {
                        assert(autoCompleteSearchItems != null, '');
                        return AutoCompleteFieldWidget<AutoCompleteItem>(
                          label: fieldConfig['label'] ?? '',
                          hintText: fieldConfig['hintText'] ?? '',
                          getName: (item) => (item as AutoCompleteItem).name,
                          items: (query, take, skip) {
                            return autoCompleteSearchItems!();
                          },
                          fetchOnInit: false,
                          // items: (query, take, skip) async {
                          //   await Future.delayed(const Duration(seconds: 1));
                          //   return [
                          //     'teste',
                          //   ];s
                          // },
                          // itemBuilder:
                          //     (BuildContext context, AutoCompleteItem item) {
                          //       return ListTile(
                          //         title: TextWidget(item.name),
                          //         onTap: () {
                          //           //
                          //         },
                          //       );
                          //     },
                          onSelected: (value) {
                            // controller.userSelected = (value as UserEntity?);
                          },
                          hideSuggestions: true,
                          suggestItems: [AutoCompleteItem('', null)],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SpacerWidget(height: 2),
                    FutureButton(
                      key: const Key('signup_button_key'),
                      text: 'save'.tr,
                      expandWidth: true,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();

                          final Map<String, dynamic> data = {};

                          for (final field in List.from(newInputFields)) {
                            final key = field['key'] ?? '';
                            final textController = controllersMap[key];
                            data[field['result_name']] = textController!.text
                                .trim();
                          }

                          try {
                            await onSave.call(data);

                            if (!context.mounted) return;
                            await DialogWidget.show(
                              context,
                              title: 'created_success_title'.tr,
                              message: 'created_success_message'.tr,
                            );

                            if (!context.mounted) return;

                            // for (final field in List.from(newInputFields)) {
                            //   if (field['readOnly'] != true) {
                            //     final key = field['key'] ?? '';
                            //     final textController = controllersMap[key];
                            //     textController!.clear();
                            //   }
                            // }
                            controller.backPage(result: true);
                          } on BaseException catch (error) {
                            if (!context.mounted) return;
                            DialogWidget.showError(
                              context,
                              message: error.message.tr,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
