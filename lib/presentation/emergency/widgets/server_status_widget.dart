import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class ServerStatusWidget extends StatelessWidget {
  final bool? status;
  final Function() onTap;

  const ServerStatusWidget({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeHelper.width(10),
          vertical: ResponsiveSizeHelper.height(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveSizeHelper.width(10),
              height: ResponsiveSizeHelper.width(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == null
                    ? Theme.of(context).disabledColor
                    : status!
                    ? SemanticColors.positive500
                    : AppColors.statusWarning,
              ),
            ),
            const SpacerWidget(),
            TextWidget(
              status == null
                  ? 'Conectando no servidor...'
                  : status!
                  ? 'WhatsApp Servidor ligado'
                  : 'WhatsApp Servidor desligado',
            ),
          ],
        ),
      ),
    );
  }
}
