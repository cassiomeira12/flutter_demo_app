import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OpenUrlServiceImpl - openUrl', () {
    late OpenUrlServiceImpl service;

    setUp(() {
      service = OpenUrlServiceImpl();
      _setupUrlLauncherMocks();
    });

    tearDown(() {
      _clearMocks();
    });

    group('Sucesso', () {
      test('deve retornar sem erro quando URL for válida', () async {
        // act & assert
        expect(
          () => service.openUrl('https://example.com'),
          returnsNormally,
        );
      });

      test('deve aceitar URL HTTPS', () async {
        // act
        await service.openUrl('https://flutter.dev');
        // assert
        expect(true, isTrue);
      });

      test('deve aceitar URL com query params', () async {
        // act
        await service.openUrl('https://example.com?key=value');
        // assert
        expect(true, isTrue);
      });

      test('deve aceitar URL http', () async {
        // act
        await service.openUrl('http://test.com');
        // assert
        expect(true, isTrue);
      });
    });

    group('Erro', () {
      test('deve lançar BaseException quando URL for vazia', () async {
        // act & assert
        expect(
          () => service.openUrl(''),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve lançar BaseException quando URL sem scheme', () async {
        // act & assert
        expect(
          () => service.openUrl('example.com'),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve lançar BaseException para URL inválida', () async {
        // act & assert
        expect(
          () => service.openUrl('notaurl'),
          throwsA(isA<BaseException>()),
        );
      });

      test(
        'deve lançar BaseException quando URL não pode ser iniciada (canLaunch false)',
        () async {
          // Setup mock to return false for canLaunch
          _setupCanLaunchFalseMock();
          // act & assert
          expect(
            () => service.openUrl('https://notfound.com'),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });

  group('OpenUrlServiceImpl - openApp', () {
    late OpenUrlServiceImpl service;

    setUp(() {
      service = OpenUrlServiceImpl();
      _setupUrlLauncherMocks();
    });

    tearDown(() {
      _clearMocks();
    });

    group('Sucesso', () {
      test('deve retornar sem erro para URL de app', () async {
        // act & assert
        expect(
          () => service.openApp('https://apps.apple.com/test'),
          returnsNormally,
        );
      });

      test('deve aceitar deep link', () async {
        // act
        await service.openApp('myapp://host');
        // assert
        expect(true, isTrue);
      });
    });

    group('Erro', () {
      test('deve lançar BaseException quando URL vazia', () async {
        // act & assert
        expect(
          () => service.openApp(''),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve lançar BaseException quando URL sem scheme', () async {
        // act & assert
        expect(
          () => service.openApp('example.com'),
          throwsA(isA<BaseException>()),
        );
      });

      test(
        'deve lançar BaseException quando canLaunch retorna false',
        () async {
          // Setup mock to return false
          _setupCanLaunchFalseMock();
          // act & assert
          expect(
            () => service.openApp('myapp://deeplink'),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });
}

void _setupUrlLauncherMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (call) async {
          if (call.method == 'canLaunch') {
            return true;
          }
          if (call.method == 'launch') {
            return true;
          }
          return null;
        },
      );
}

void _setupCanLaunchFalseMock() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (call) async {
          if (call.method == 'canLaunch') {
            return false;
          }
          if (call.method == 'launch') {
            return true;
          }
          return null;
        },
      );
}

void _clearMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        null,
      );
}
