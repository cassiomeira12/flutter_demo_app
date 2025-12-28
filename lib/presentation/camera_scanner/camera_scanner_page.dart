import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/camera_scanner/widgets/camera.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';

class CameraScannerPage extends AppView<CameraScannerController> {
  const CameraScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '',
      controller: controller,
      body: QrCodeScannerWidget(
        capture: (String? qrcode) {
          Log.info('QR Code scanned data: $qrcode');
          controller.backPage(result: qrcode);
        },
      ),
    );
  }
}
