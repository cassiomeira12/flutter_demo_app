import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebVisitHistoryWidget extends StatelessWidget {
  final WebVisitHistoryEntity webVisitHistoryEntity;

  const WebVisitHistoryWidget({
    super.key,
    required this.webVisitHistoryEntity,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: ResponsiveSizeHelper.width(24),
        height: ResponsiveSizeHelper.width(24),
        child: ImageWidget(imageUrl: webVisitHistoryEntity.countryFlag ?? ''),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                webVisitHistoryEntity.ip,
                style: AppTextStyle.footnote(context),
              ),
              if (webVisitHistoryEntity.createdAt != null)
                TextWidget(
                  DateHelper.formatDate(webVisitHistoryEntity.createdAt!),
                  style: AppTextStyle.footnote(context),
                ),
            ],
          ),
          if (webVisitHistoryEntity.countryComplete.isNotEmpty)
            TextWidget(
              webVisitHistoryEntity.countryComplete,
              style: AppTextStyle.footnote(context),
            ),
        ],
      ),
      subtitle: TextWidget(
        webVisitHistoryEntity.website,
        style: AppTextStyle.footnote(context),
      ),
    );
  }
}
