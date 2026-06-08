import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    AppBinding.put<ServerEnvironmentEntity>(
      ServerEnvironmentEntity(
        serverUrl: 'https://fakestoreapi.com',
      ),
      permanent: true,
    );

    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  group('test http client', () {
    test('test get function success', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/users',
      );

      final response = await http.get<List<dynamic>>(request);

      expect(response.statusCode, 200);
      expect(response.data is List<dynamic>, true);
    });

    test('test post function success', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/products',
        data: {
          'title': 'test product',
          'price': 13.5,
          'description': 'lorem ipsum set',
          'image': 'https://i.pravatar.cc',
          'category': 'electronic',
        },
      );

      final response = await http.post<Map<String, dynamic>>(request);

      expect(response.statusCode, 201);
      expect(response.data is Map<String, dynamic>, true);
    });

    test('test put function success', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/products/7',
        data: {
          'title': 'test product',
          'price': 13.5,
          'description': 'lorem ipsum set',
          'image': 'https://i.pravatar.cc',
          'category': 'electronic',
        },
      );

      final response = await http.put<Map<String, dynamic>>(request);

      expect(response.statusCode, 200);
      expect(response.data is Map<String, dynamic>, true);
    });

    test('test delete function success', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/products/6',
      );

      final response = await http.delete(request);

      expect(response.statusCode, 200);
      expect(response.data is Map<String, dynamic>, true);
    });

    test('test get function error', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/cartsfake',
      );

      try {
        await http.get<List<dynamic>>(request);
      } on HttpException catch (error) {
        expect(error.statusCode, 404);
      }
    });

    test('test post function error', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/auth/login',
        data: {
          'username': 'mor_2314',
          'password': '83r5',
        },
      );

      try {
        await http.post<List<dynamic>>(request);
      } on HttpException catch (error) {
        expect(error.statusCode, 401);
      }
    });

    test('test put function error', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/carts/7/teste',
        data: {
          'id': 3,
          'date': '2019 - 12 - 10',
        },
      );

      try {
        await http.put<Map<String, dynamic>>(request);
      } on HttpException catch (error) {
        expect(error.statusCode, 404);
      }
    });

    test('test delete function error', () async {
      final http = AppBinding.find<HttpClient>();

      final request = HttpRequest(
        url: '/products/teste',
      );

      try {
        await http.delete<Map<String, dynamic>>(request);
      } on HttpException catch (error) {
        expect(error.statusCode, 400);
      }
    });
  });
}
