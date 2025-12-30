import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class EmergencyController extends BaseController {
  final CheckWhatsAppServerUseCase _checkWhatsAppServerUseCase;
  final SendSosUseCase _sendSosUseCase;

  final CheckPermissionUseCase _checkPermissionUseCase;
  //final RequestPermissionUseCase _requestPermissionUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  //final ITrackLocationUseCase _trackLocationUseCase;

  EmergencyController({
    required CheckWhatsAppServerUseCase checkWhatsAppServerUseCase,
    required SendSosUseCase sendSosUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    //required IRequestPermissionUseCase requestPermissionUseCase,
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    //required ITrackLocationUseCase trackLocationUseCase,
  }) : _checkWhatsAppServerUseCase = checkWhatsAppServerUseCase,
       _sendSosUseCase = sendSosUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       //_requestPermissionUseCase = requestPermissionUseCase,
       _getCurrentLocationUseCase = getCurrentLocationUseCase;
  //_trackLocationUseCase = trackLocationUseCase;

  Rx<Color> sosStatusColor = Rx<Color>(const Color(0xFFF35E27));
  RxString sosStatusMessage = 'emergency_sos_message'.tr.obs;

  Rxn<AnimationController> animationController = Rxn();
  bool _sendingSOS = false;
  bool _enableToCancelSOS = true;
  bool _cancelSendingSOS = false;
  bool sendSOScancelled = false;

  RxnBool whatsAppServer = RxnBool();

  @override
  String get pageRouteNamed => AppRouter.emergency.name;

  @override
  void onReady() {
    super.onReady();
    checkWhatsAppServer();
  }

  Future<void> checkWhatsAppServer() async {
    try {
      whatsAppServer.value = null;
      whatsAppServer.value = await _checkWhatsAppServerUseCase.call();
    } catch (error) {
      whatsAppServer.value = false;
    }
  }

  Future<int?> sendSOS(int choice) async {
    try {
      _sendingSOS = true;
      _enableToCancelSOS = true;
      _cancelSendingSOS = false;
      // if (!await gpsInterface.hasPermission()) {
      //   var gpsEnable = await Get.toNamed(SignUpRouter.gpsPermission);
      //   if (gpsEnable == null) {
      //     throw 'emergency_sos_gps_permission_error';
      //   } else if (!gpsEnable) {
      //     throw 'emergency_sos_gps_permission_error';
      //   }
      // }
    } catch (error) {
      _sendingSOS = false;
      _resetStatusMessage(message: '$error'.tr);
      rethrow;
    }

    PermissionStatus? hasLocationPermission = await _checkPermissionUseCase
        .call(Permission.location);

    if (!hasLocationPermission.isGranted) {
      // hasLocationPermission = await AppNavigator.to(
      //   () => const PermissionRequestWidget(
      //     permission: Permission.location,
      //   ),
      //   ignoreId: true,
      // );
      // if (hasLocationPermission == null) {
      //   sendSOScancelled = true;
      //   _sendingSOS = false;
      //   throw BaseException(message: 'location_is_required'.tr);
      // }
    }

    // if (!authController.user.value!.phoneVerified) {
    //   Get.toNamed(SignUpRouter.phoneNumber);
    //   sendSOScancelled = true;
    //   cancelSendingSOS();
    //   _sendingSOS = false;
    //   return null;
    // }

    if (_cancelSendingSOS) {
      sendSOScancelled = true;
      _sendingSOS = false;
      return null;
    }

    sosStatusMessage.value = 'check_server_connections'.tr;
    sosStatusColor.value = AppColors.statusWarning; // Colors.yellow.shade700;

    // List results = await Future.wait(
    //   eagerError: true,
    //   [_checkServerON(), _getGPSLocation()],
    // );

    final LocationEntity location = await _getCurrentLocationUseCase.call();

    // LatLong location = results.last as LatLong;

    return await _sendSOSServer(
      choice: SosChoiceEnum.SAFETY_CONTACTS_ONLY,
      location: location,
    );
  }

  Future<void> _resetStatusMessage({String? message}) async {
    sosStatusMessage.value = message ?? 'emergency_sos_message'.tr;
    sosStatusColor.value = const Color(0xFFF35E27);
  }

  bool cancelSendingSOS() {
    if (_enableToCancelSOS) {
      _cancelSendingSOS = true;
      _resetStatusMessage();
      animationController.value?.stop();
      return _sendingSOS && true;
    }
    return false;
  }

  Future<int> _sendSOSServer({
    required SosChoiceEnum choice,
    required LocationEntity location,
  }) async {
    try {
      _enableToCancelSOS = false;
      sosStatusMessage.value = 'emergency_sos_send_sos'.tr;
      sosStatusColor.value = const Color(0xFF039BE5);

      final int messagesSent = await _sendSosUseCase.call(
        choice: choice.code,
        latitude: location.latitude,
        longitude: location.longitude,
        accuracy: location.accuracy?.toInt() ?? 0,
      );

      sosStatusMessage.value = 'emergency_sos_successful'.tr;
      sosStatusColor.value = AppColors.statusSuccess;
      return messagesSent;
    } catch (error) {
      _resetStatusMessage(message: 'emergency_sos_send_error'.tr);
      rethrow;
    } finally {
      _sendingSOS = false;
      _enableToCancelSOS = true;
    }
  }
}
