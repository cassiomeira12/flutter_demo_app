import 'package:core/core.dart';

class AppEnUsTranslation extends EnUsTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app':
            'A simple and efficient app for quickly and securely recording your work hours. Control your clock-ins, clock-outs, and breaks in real time, track your workday, and keep your history always organized.',
        'remember_my_credentials': 'Remember my credentials',
        'change_month': 'Change month',
        'holiday': 'Holiday',
        'allowance': 'Allowance',
        'day_off': 'Day off',
        'weekend': 'Weekend',
        'total_hours': 'Total hours',
        'total_budget': 'Budget',
        'make_check_point': 'Make check point',
        'make_check_point_now': 'Do you want to check point now?',
        'empty_check_point_list': "You haven't registered any points yet.",
        'date': 'Date',
        'has_inconsistency': 'Has inconsistency',
        'delete_check_point': 'Delete check point',
        'delete_check_point_selected':
            'Do you want to delete the point {checkHourPoint}h ?',
        'check_point': 'Point',
        'set_to_holiday': 'Mark the day as a holiday',
        'set_to_allowance': 'Mak the day as a allowance',
        'set_to_day_off': 'Mark the day as a day off',
        'work_point_already_created':
            'Your point has already been registered at {hourPoint}h',
        'justification': 'Justification',
        'justification_hint': 'Enter a justification',
      },
    };
  }
}
