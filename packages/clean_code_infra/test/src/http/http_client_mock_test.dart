import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    AppBinding.put<HttpClient>(
      HttpClientMock(),
      permanent: true,
    );
  });

  test('test get function success 1', () async {
    final http = AppBinding.find<HttpClient>();

    final request = HttpRequest(
      url: '/users',
    );

    when(
      () => http.get(request),
    ).thenAnswer((_) async {
      return HttpResponse(
        statusCode: 201,
        data: [],
      );
    });

    final response = await http.get(request);

    expect(response.statusCode, 201);
    expect(response.data is List<dynamic>, true);
  });

  test('test get function success', () async {
    final http = AppBinding.find<HttpClient>();

    final request = HttpRequest(
      url: '/users',
    );

    when(
      () => http.get(request),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
      ),
    );

    expect(
      () => http.get(request),
      throwsA(
        isA<DioException>(),
      ),
    );

    await expectLater(
      () => http.get(request),
      throwsA(
        isA<DioException>(),
      ),
    );

    try {
      final response = await http.get(request);

      expect(response.statusCode, 201);
      expect(response.data is List<dynamic>, true);
    } catch (error) {
      expect(error is DioException, true);
    }
  });
}
