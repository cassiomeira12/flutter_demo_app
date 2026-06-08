import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/widgets/otp_widget.dart';

class CredentialWidget extends StatelessWidget {
  final CredentialEntity credential;
  final GestureTapCallback onTap;
  final void Function(String url, Object? error)? onError;

  const CredentialWidget({
    super.key,
    required this.credential,
    required this.onTap,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
      constraints: const BoxConstraints(minHeight: kToolbarHeight),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSizeHelper.spacingDefaultWidth,
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveSizeHelper.width(38),
                height: ResponsiveSizeHelper.width(38),
                margin: EdgeInsets.only(
                  right: ResponsiveSizeHelper.spacingDefaultWidth,
                ),
                child: ImageWidget(
                  imageUrl: credential.favIconUrlFormatted,
                  onError: onError,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      credential.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (credential.userName != null)
                      TextWidget(
                        credential.userName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.label(context),
                      ),
                  ],
                ),
              ),
              if (credential.secretKeyOTP != null)
                Container(
                  height: kToolbarHeight,
                  padding: EdgeInsets.only(
                    left: ResponsiveSizeHelper.width(12),
                  ),
                  child: OtpWidget(
                    initialShow: true,
                    secretKeyOTP: credential.secretKeyOTP!,
                    getOtpCodeUseCase: AppBinding.find(),
                    clipboardUseCase: AppBinding.find(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
