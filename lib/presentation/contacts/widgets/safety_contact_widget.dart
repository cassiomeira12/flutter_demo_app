import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class SafetyContactWidget extends StatefulWidget {
  final SafetyContactEntity safetyContactEntity;
  final Future<void> Function(String objectId) onDelete;

  const SafetyContactWidget({
    super.key,
    required this.safetyContactEntity,
    required this.onDelete,
  });

  @override
  State<SafetyContactWidget> createState() => _SafetyContactWidgetState();
}

class _SafetyContactWidgetState extends State<SafetyContactWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: ListTile(
        onTap: () {},
        leading: SizedBox(
          width: ResponsiveSizeHelper.width(40),
          height: ResponsiveSizeHelper.width(40),
          child: const FlutterIcon(
            BoxIcons.bx_user,
            size: IconSize.medium,
          ),
        ),
        title: TextWidget(
          widget.safetyContactEntity.name,
          // style: fontField(context, bold: true),
        ),
        subtitle: TextWidget(
          widget.safetyContactEntity.phoneNumber,
          // style: fontField(context, size: 15),
        ),
        trailing: SizedBox(
          width: ResponsiveSizeHelper.width(38),
          height: ResponsiveSizeHelper.width(38),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (loading)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: ResponsiveSizeHelper.maxHeight * .01,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              if (!loading)
                IconButtonWidget(
                  key: Key(
                    'remove_safety_contact_${widget.safetyContactEntity.phoneNumber}_key',
                  ),
                  icon: const FlutterIcon(
                    BoxIcons.bx_trash,
                    color: AppColors.statusWarning,
                  ),
                  onPressed: () async {
                    final accepted = await DialogWidget.showChoice(
                      context,
                      title: 'remove'.tr,
                      message:
                          '${'remove_contact_message'.tr} ${widget.safetyContactEntity.name} ?',
                    );
                    if (accepted == true) {
                      setState(() => loading = true);
                      try {
                        await widget.onDelete.call(
                          widget.safetyContactEntity.objectId,
                        );
                        if (!context.mounted) return;
                        DialogWidget.show(
                          context,
                          title: 'deleted_contact_success_title'.tr,
                          message: 'deleted_contact_success_message'.tr,
                        );
                      } on BaseException catch (error) {
                        if (!context.mounted) return;
                        DialogWidget.show(
                          context,
                          title: 'default_error'.tr,
                          message: error.toString().tr,
                        );
                      } finally {
                        if (mounted) {
                          setState(() => loading = false);
                        }
                      }
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
