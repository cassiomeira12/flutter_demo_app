import 'package:core/core.dart';

class AppEnUsTranslation extends EnUsTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'remember_my_credentials': 'Remember my credentials',
        'change_month': 'Change month',
        'holiday': 'Holiday',
        'weekend': 'Weekend',
        'total_hours': 'Total hours',
        'total_budget': 'Budget',
        'make_check_point': 'Make check point',
        'make_check_point_now': 'Do you want to check point now?',
      },
    };
  }
}
