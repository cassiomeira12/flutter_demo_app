import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';
import 'package:flutter_demo_app/presentation/credentials/widgets/credential_widget.dart';

class CredentialsPage extends AppView<CredentialsController> {
  const CredentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'credentials'.tr,
      controller: controller,
      appBarActions: [
        IconButtonWidget(
          icon: FlutterIcon(
            Icons.search,
            size: IconSize.medium,
            color: Theme.of(context).textTheme.labelLarge?.color,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: AppBarSearchDelegate<ValueNotifier<CredentialEntity>>(
                items: controller.credentials.value,
                filter: (item) => item.value.name,
                emptyMessage: 'search_credentials_not_found'.tr,
                builder: (context, valueListenable) {
                  return ValueListenableBuilder<CredentialEntity>(
                    valueListenable: valueListenable,
                    builder: (context, credential, child) {
                      return CredentialWidget(
                        credential: credential,
                        onError: (url, error) {
                          controller.errorFavIcon(credential);
                        },
                        onTap: () {
                          controller.openCredential(credential);
                          HapticFeedback.lightImpact();
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
      appBarPopUpMenuItems: [
        PopupMenuItem(
          key: const Key('credentials_update_popup_menu_item_key'),
          value: 'update'.tr,
          onTap: controller.getAllCredentials,
          child: TextWidget(
            'update'.tr,
          ),
        ),
      ],
      body: ScrollStateNotifierWidget<CredentialEntity>(
        valueListenable: controller.credentials,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.getAllCredentials,
        emptyMessage: 'empty_credentials_list'.tr,
        fromMapBuilder: (map) {
          return CredentialModel.fromMap(map).copyWith();
        },
        skeletonSizeItems: 10,
        toMapBuilder: (item) => item.toMap(),
        scrollController: (scrollController) {
          controller.scrollController = scrollController;
        },
        builder: (context, index, item) {
          return CredentialWidget(
            key: ValueKey('credential_item_index_${index}_key'),
            credential: item,
            onError: (url, error) {
              controller.errorFavIcon(item);
            },
            onTap: () {
              controller.openCredential(item);
              HapticFeedback.lightImpact();
            },
          );
        },
      ),
      // body: Obx(() {
      //   if (controller.isLoading.value) {
      //     return const Center(child: ProgressBarWidget());
      //   }
      //   return ValueListenableBuilder<List<ValueNotifier<CredentialEntity>>>(
      //     valueListenable: controller.credentials,
      //     builder: (context, list, child) {
      //       return ListView.builder(
      //         itemCount: list.length,
      //         itemBuilder: (context, index) {
      //           return ValueListenableBuilder<CredentialEntity>(
      //             valueListenable: list.elementAt(index),
      //             builder: (context, credential, child) {
      //               return CredentialWidget(
      //                 key: ValueKey('credential_item_index_${index}_key'),
      //                 credential: credential,
      //                 onTap: () {
      //                   controller.openCredential(credential);
      //                   HapticFeedback.lightImpact();
      //                 },
      //               );
      //             },
      //           );
      //         },
      //       );
      //     },
      //   );
      // }),
      /*body: ScrollStateWidget<CredentialEntity>(
        list: controller.credentials,
        errorMessage: controller.errorMessage,
        isLoading: controller.isLoading,
        onRefresh: controller.getAllCredentials,
        emptyMessage: 'empty_credentials_list'.tr,
        fromMapBuilder: (map) {
          return CredentialModel.fromMap(map).copyWith();
        },
        skeletonSizeItems: 10,
        toMapBuilder: (item) => item.toMap(),
        scrollController: (scrollController) {
          controller.scrollController = scrollController;
        },
        builder: (context, index, item) {
          return CredentialWidget(
            key: ValueKey('credential_item_index_${index}_key'),
            credential: item,
            onTap: () {
              controller.openCredential(item);
              HapticFeedback.lightImpact();
            },
          );
        },
      ),*/
      floatingActionButton: FloatingButtonWidget(
        key: const Key('add_new_credential_button_key'),
        icon: const FlutterIcon(Icons.add, color: AppColors.white),
        onPressed: () {
          controller.addCredential();
        },
      ),
    );
  }
}
