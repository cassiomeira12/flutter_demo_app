import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ScrollStateWidget<T> extends StatelessWidget {
  final RxList<T> list;
  final RxBool isLoading;
  final RxString errorMessage;
  final Future<void> Function() onRefresh;
  final String emptyMessage;
  final Widget Function(BuildContext context, int index, T item) builder;
  final int skeletonSizeItems;
  final T Function(Map<String, dynamic> map)? fromMapBuilder;
  final Map<String, dynamic> Function(T item)? toMapBuilder;
  final void Function(ScrollController scrollController)? scrollController;

  const ScrollStateWidget({
    super.key,
    required this.list,
    required this.isLoading,
    required this.errorMessage,
    required this.onRefresh,
    required this.emptyMessage,
    required this.builder,
    this.skeletonSizeItems = 5,
    this.fromMapBuilder,
    this.toMapBuilder,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        if (fromMapBuilder != null && toMapBuilder != null) {
          try {
            final T emptyItem = fromMapBuilder!.call({});
            final map = toMapBuilder!.call(emptyItem).map((key, value) {
              return MapEntry(key, value is String ? '$key $key $key' : value);
            });
            final T item = fromMapBuilder!.call(map);
            return Skeletonizer(
              child: ListView.separated(
                itemCount: skeletonSizeItems,
                itemBuilder: (context, index) {
                  return builder(context, index, item);
                },
                separatorBuilder: (context, index) {
                  return const SpacerWidget(height: 0);
                },
              ),
            );
          } catch (_) {}
        }
        return const CircularLoadingWidget();
      }
      if (errorMessage.value.isNotEmpty) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveSizeHelper.width(20),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveSizeHelper.height(30),
                horizontal: ResponsiveSizeHelper.width(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlutterIcon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                    size: IconSize.bigger,
                  ),
                  const SpacerWidget(),
                  TextWidget(
                    errorMessage.value.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.subtitle(context),
                  ),
                  const SpacerWidget(height: 2),
                  SecondaryButton(
                    text: 'try_again'.tr,
                    onPressed: onRefresh,
                    size: ButtonSize.medium,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (list.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSizeHelper.width(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.subtitle(context),
                ),
              ],
            ),
          ),
        );
      }
      return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), onRefresh);
        },
        child: ScrollViewWidget(
          child: (scrollController) {
            this.scrollController?.call(scrollController);
            return ListView.builder(
              controller: scrollController,
              itemCount: list.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final T item = list.elementAt(index);
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == list.length - 1
                        ? ResponsiveSizeHelper.height(200)
                        : 0,
                  ),
                  child: builder(context, index, item),
                );
              },
            );
          },
        ),
      );
    });
  }
}
