import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class OpenUrlServiceImpl implements OpenUrlService {
  @override
  Future<void> openApp(String url) async {
    try {
      return await _launch(url);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    }
  }

  @override
  Future<void> openUrl(String url) async {
    try {
      return await _launch(url, mode: LaunchMode.externalApplication);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    }
  }

  Future<void> _launch(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      if (url.isEmpty) {
        throw ArgumentError('URL cannot be empty');
      }

      final uri = Uri.parse(url);

      if (!uri.hasScheme) {
        throw ArgumentError('URL must have valid scheme: $uri');
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (error, stackTrace) {
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
