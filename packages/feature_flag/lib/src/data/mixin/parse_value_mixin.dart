import 'dart:convert';

import 'package:core/core.dart';

mixin ParseValueMixin {
  RemoteFlag<T> parseValueType<T>({
    required RemoteFlagsEnum flag,
    required bool isEnabled,
    required String? value,
  }) {
    if (flag.type == int) {
      return RemoteFlag<T>(
        isEnabled: isEnabled,
        value: int.tryParse(value!) as T?,
      );
    }

    if (flag.type == double) {
      return RemoteFlag<T>(
        isEnabled: isEnabled,
        value: double.tryParse(value!) as T?,
      );
    }

    if (flag.type == bool) {
      return RemoteFlag<T>(
        isEnabled: isEnabled,
        value: bool.tryParse(value!) as T?,
      );
    }

    if (flag.type.toString().contains('Map')) {
      return RemoteFlag<T>(
        isEnabled: isEnabled,
        value: value == null ? null : jsonDecode(value) as T,
      );
    }

    return RemoteFlag<T>(
      isEnabled: isEnabled,
      value: value as T?,
    );
  }
}
