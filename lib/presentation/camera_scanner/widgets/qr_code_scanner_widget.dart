import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class QrCodeScannerWidget extends StatefulWidget {
  final ValueChanged<String?> capture;

  const QrCodeScannerWidget({
    super.key,
    required this.capture,
  });

  @override
  State<QrCodeScannerWidget> createState() => _QrCodeScannerWidgetState();
}

class _QrCodeScannerWidgetState extends State<QrCodeScannerWidget> {
  late MobileScannerController _controller;
  Timer? _scannerTimer;

  final StreamController<bool> _showWidget = StreamController();

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      invertImage: true,
      detectionTimeoutMs: 1500,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      _showWidget.add(true);
    });
  }

  @override
  void dispose() {
    _showWidget.close();
    _scannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _showWidget.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Stack(
            alignment: Alignment.center,
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: (BarcodeCapture result) {
                  if (_scannerTimer?.isActive ?? false) _scannerTimer?.cancel();
                  _scannerTimer = Timer(const Duration(seconds: 1), () {
                    widget.capture.call(result.barcodes.first.rawValue);
                  });
                },
                placeholderBuilder: _loadingWidget,
              ),
              BarcodeOverlay(
                controller: _controller,
                boxFit: BoxFit.contain,
              ),
              ScanWindowOverlay(
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                scanWindow: Rect.fromCenter(
                  center: MediaQuery.sizeOf(
                    context,
                  ).center(const Offset(0, -kToolbarHeight)),
                  width: 300,
                  height: 300,
                ),
                controller: _controller,
              ),
            ],
          );
        }
        return _loadingWidget(context);
      },
    );
  }

  Widget _loadingWidget(BuildContext context) {
    return const Center(
      child: FlutterIcon(
        Icons.camera_alt,
        size: IconSize.large,
      ),
    );
  }
}
