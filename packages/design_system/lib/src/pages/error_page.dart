import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;
  final VoidCallback? onTryAgain;

  const ErrorPage({
    super.key,
    this.errorDetails,
    this.errorMessage,
    this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      hideAppBar: true,
      controller: null,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSizeHelper.width(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterIcon(
                Icons.warning,
                size: IconSize.bigger,
                color: Theme.of(context).colorScheme.error,
              ),
              TextWidget(
                'Oops, algo deu errado!',
                style: AppTextStyle.subtitle(
                  context,
                  fontSize: TextSize.font_20,
                ),
              ),
              const SpacerWidget(height: 2),
              TextWidget(
                'Tivemos um problema interno. Tente novamente em alguns instantes.',
                style: AppTextStyle.message(
                  context,
                  fontSize: TextSize.font_14,
                ),
                textAlign: TextAlign.center,
              ),
              const SpacerWidget(height: 2),
              // if (kDebugMode) TextWidget(errorDetails.exception.toString()),
              const SpacerWidget(),
              if (onTryAgain != null)
                PrimaryButton(
                  text: 'Tentar novamente',
                  backgroundColor: Theme.of(context).colorScheme.error,
                  onPressed: onTryAgain,
                ),
            ],
          ),
        ),
      ),
      // bottomWidget: Center(
      //   child: PrimaryButton(
      //     text: 'Voltar',
      //     onPressed: () {
      //       AppNavigator.back();
      //     },
      //   ),
      // ),
    );
  }
}
