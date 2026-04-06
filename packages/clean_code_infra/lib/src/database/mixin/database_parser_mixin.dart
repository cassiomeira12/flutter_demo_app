import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

mixin DatabaseParserMixin {
  String encodeValue<T>(T value) {
    if (value is num || value is bool || value is String) {
      return value.toString();
    }

    if (value is List) {
      return (value as List).map((item) => item.toString()).toList().toString();
    }

    if (value is Map) {
      return jsonEncode(value);
    }

    return value.toString();
  }

  T decodeValue<T>(String value) {
    if (T == int || T == double) return num.parse(value) as T;

    if (T == bool) return bool.parse(value) as T;

    if (T == String) return value as T;

    if (T == List<int>) {
      return _splitList(value).map((item) {
            return int.parse(item.trim());
          }).toList()
          as T;
    }

    if (T == List<double>) {
      return _splitList(value).map((item) {
            return double.parse(item.trim());
          }).toList()
          as T;
    }

    if (T == List<bool>) {
      return _splitList(value).map((item) {
            return bool.parse(item.trim());
          }).toList()
          as T;
    }

    if (T == List<String>) {
      return _splitList(value).toList() as T;
    }

    if (T.toString().contains('Map')) {
      return jsonDecode(value) as T;
    }

    throw BaseException(message: 'Type $T is not acceptable');
  }

  Iterable<String> _splitList(String item) {
    return item
        .substring(1, item.length - 1)
        .split(',')
        .map((item) => item.trim())
        .toList();
  }
}
