import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ErrorPage extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? message;
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;
  final VoidCallback? onTryAgain;

  const ErrorPage({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.errorDetails,
    this.errorMessage,
    this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      hideAppBar: true,
      controller: null,
      runPopGesture: false,
      body: Center(
        child: Padding(
          padding: ResponsiveSizeHelper.defaultHorizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterIcon(
                icon ?? Icons.warning,
                size: IconSize.bigger,
                color: Theme.of(context).colorScheme.error,
              ),
              TextWidget(
                title ?? 'error_page_title'.tr,
                style: AppTextStyle.subtitle(
                  context,
                  fontSize: TextSize.font_20,
                ),
              ),
              const SpacerWidget(height: 2),
              TextWidget(
                message ?? 'error_page_message'.tr,
                style: AppTextStyle.message(
                  context,
                  fontSize: TextSize.font_14,
                ),
                textAlign: TextAlign.center,
              ),
              const SpacerWidget(height: 2),
              if (onTryAgain != null)
                PrimaryButton(
                  text: 'try_again'.tr,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  onPressed: onTryAgain,
                  size: ButtonSize.medium,
                ),
              if (!kReleaseMode)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSizeHelper.spacingDefaultHeight,
                  ),
                  child: TextWidget(
                    errorMessage.toString(),
                    style: AppTextStyle.error(context),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
