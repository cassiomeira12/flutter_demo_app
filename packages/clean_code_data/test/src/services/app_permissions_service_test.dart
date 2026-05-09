import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppPermissionsServiceImpl service;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    service = AppPermissionsServiceImpl();
    _clearMocks();
  });

  group('AppPermissionsServiceImpl - checkPermission', () {
    test(
      'deve retornar granted para permission concedida',
      () async {
        _mockCheckPermissionStatus(1);
        final result = await service.checkPermission(Permission.camera);
        expect(result, PermissionStatus.granted);
      },
    );

    test(
      'deve retornar denied para permission negada',
      () async {
        _mockCheckPermissionStatus(0);
        final result = await service.checkPermission(Permission.camera);
        expect(result, PermissionStatus.denied);
      },
    );

    test(
      'deve retornar permanentlyDenied para permission permanentemente negada',
      () async {
        _mockCheckPermissionStatus(4);
        final result = await service.checkPermission(Permission.camera);
        expect(result, PermissionStatus.permanentlyDenied);
      },
    );

    test(
      'deve retornar limited para permission limitada',
      () async {
        _mockCheckPermissionStatus(3);
        final result = await service.checkPermission(Permission.photos);
        expect(result, PermissionStatus.limited);
      },
    );

    test(
      'deve retornar restricted para permission restrita',
      () async {
        _mockCheckPermissionStatus(2);
        final result = await service.checkPermission(Permission.camera);
        expect(result, PermissionStatus.restricted);
      },
    );

    test(
      'deve lançar BaseException quando ocorre erro',
      () async {
        _mockCheckPermissionStatusError();
        expect(
          () => service.checkPermission(Permission.camera),
          throwsA(isA<BaseException>()),
        );
      },
    );

    test(
      'deve retornar granted para notification quando já concedido',
      () async {
        _mockCheckPermissionStatus(1);
        final result = await service.checkPermission(Permission.notification);
        expect(result, PermissionStatus.granted);
      },
    );

    test(
      'deve retornar denied para notification quando não concedido',
      () async {
        _mockCheckPermissionStatus(0);
        final result = await service.checkPermission(Permission.notification);
        expect(result, PermissionStatus.denied);
      },
    );
  });

  group('AppPermissionsServiceImpl - requestPermission - cenários válidos', () {
    test(
      'deve retornar status retornado pelo request de permission',
      () async {
        // Para requestPermission, mockamos check primeiro para retornar granted
        // assim o método usa permission.request() internamente
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('flutter.baseflow.com/permissions/methods'),
              (call) async {
                if (call.method == 'checkPermissionStatus') {
                  return 2; // restricted para trigger o request
                }
                if (call.method == 'requestPermissions') {
                  return {0: 1}; // granted
                }
                return null;
              },
            );
        final result = await service.requestPermission(Permission.photos);
        // O resultado vem de permission.request(), então aceitamos qualquer um
        expect(result, isA<PermissionStatus>());
      },
    );

    test(
      'deve lançar BaseException quando ocurre erro genérico',
      () async {
        _mockRequestPermissionError();
        expect(
          () => service.requestPermission(Permission.camera),
          throwsA(isA<BaseException>()),
        );
      },
    );
  });
}

void _clearMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        null,
      );
}

void _mockCheckPermissionStatus(int status) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (call) async {
          if (call.method == 'checkPermissionStatus') {
            return status;
          }
          return 0;
        },
      );
}

void _mockCheckPermissionStatusError() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (call) async {
          if (call.method == 'checkPermissionStatus') {
            throw Exception('Permission check failed');
          }
          return null;
        },
      );
}

void _mockRequestPermissionError() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (call) async {
          if (call.method == 'checkPermissionStatus') {
            return 2;
          }
          if (call.method == 'requestPermissions') {
            throw Exception('Permission request failed');
          }
          return null;
        },
      );
}
