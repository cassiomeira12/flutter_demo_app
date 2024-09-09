import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/infra/http/exceptions/exceptions.dart';
import 'package:flutter_demo_app/infra/http/http_request.dart';

class FakeDataSource implements IFakeDataSource {
  final Http _http;

  FakeDataSource({
    required Http http,
  }) : _http = http;

  @override
  Future<void> call() async {
    try {
      final request = HttpRequest(url: '');

      await _http.get<void>(request);

      //
    } on HttpException catch (_) {
      throw Exception();
    }
  }
}
