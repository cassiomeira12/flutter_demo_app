import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AppBarSearchDelegate<T> extends SearchDelegate<T?> {
  final List<T> _items;
  final String Function(T item) filter;
  final String emptyMessage;
  final Widget Function(BuildContext context, T item) builder;

  AppBarSearchDelegate({
    required List<T> items,
    required this.filter,
    required this.emptyMessage,
    required this.builder,
  }) : _items = items;

  List<T> results = <T>[];

  @override
  String? get searchFieldLabel => 'search'.tr;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButtonWidget(
        icon: const FlutterIcon(
          Icons.clear,
          size: IconSize.medium,
          color: AppColors.statusWarning,
        ),
        onPressed: () => query.isEmpty ? close(context, null) : query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: TextWidget(
          emptyMessage,
          textAlign: TextAlign.center,
          style: AppTextStyle.subtitle(context),
        ),
      );
    }
    return ScrollViewWidget(
      child: (scrollController) {
        return ListView.separated(
          controller: scrollController,
          itemCount: results.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == results.length - 1
                    ? ResponsiveSizeHelper.height(200)
                    : 0,
              ),
              child: builder(context, results[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerWidget(height: 0);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    results = _items.where((T credential) {
      final String itemFilter = filter(credential);
      final escapedQuery = RegExp.escape(query);
      final regex = RegExp(escapedQuery, caseSensitive: false);
      return regex.hasMatch(itemFilter);
    }).toList();
    return buildResults(context);
  }
}
