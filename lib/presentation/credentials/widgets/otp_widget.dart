import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class OtpWidget extends StatefulWidget {
  final bool initialShow;
  final String secretKeyOTP;
  final GetOtpCodeUseCase _getOtpCodeUseCase;
  final ClipboardUseCase _clipboardUseCase;

  const OtpWidget({
    super.key,
    this.initialShow = false,
    required this.secretKeyOTP,
    required GetOtpCodeUseCase getOtpCodeUseCase,
    required ClipboardUseCase clipboardUeCase,
  }) : _getOtpCodeUseCase = getOtpCodeUseCase,
       _clipboardUseCase = clipboardUeCase;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  late bool _running;

  @override
  void initState() {
    _running = widget.initialShow;
    super.initState();
  }

  Stream<int> _clock() async* {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield DateTime.now().second;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_running) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeHelper.width(10),
        ),
        alignment: Alignment.center,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSizeHelper.width(10)),
            child: TextWidget(
              '******'.replaceRange(3, 3, ' '),
              style: AppTextStyle.message(
                context,
                fontSize: TextSize.font_16,
              ),
            ),
          ),
          onTap: () {
            setState(() => _running = true);
          },
        ),
      );
    }
    return StreamBuilder(
      stream: _clock(),
      builder: (context, AsyncSnapshot<int> snapshot) {
        final double percentage = (((snapshot.data ?? 0) % 30) / 30) * 100;
        final String code = widget._getOtpCodeUseCase.call(
          secret: widget.secretKeyOTP,
        );
        return InkWell(
          onTap: () {
            widget._clipboardUseCase.copy(code, autoClear: true).then((_) {
              if (!context.mounted) return;
              if (!widget.initialShow) {
                setState(() => _running = false);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: TextWidget(
                    'otp_code_copied'.tr.replaceFirst('{otp_code}', code),
                  ),
                ),
              );
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSizeHelper.width(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                TextWidget(
                  code.replaceRange(3, 3, ' '),
                  style: AppTextStyle.message(
                    context,
                    fontSize: TextSize.font_16,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: ProgressBarWidget(
                    percentage: percentage,
                    segments: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
