import 'package:dependency/dependency.dart';

abstract class DateHelper {
  static DateTime parse(String date) {
    return DateTime.parse(date).toLocal();
  }

  static String getTimeToNow(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} h';
    } else if (diff.inDays < 365) {
      return '${diff.inDays} d';
    } else {
      return '${diff.inDays / 365} a';
    }
  }

  static String getTimeFromNow(DateTime date) {
    final diff = date.difference(DateTime.now());

    if (diff.inDays < 30) {
      return '${diff.inDays} dias';
    } else if (diff.inDays < 60) {
      return '${diff.inDays ~/ 30} mês';
    } else if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30} meses';
    } else if (diff.inDays < 730) {
      return '${diff.inDays ~/ 365} ano';
    } else {
      return '${diff.inDays ~/ 365} anos';
    }
  }

  static String formatDateMonth(DateTime date) {
    // [10 de jan]
    String result = '${date.day} de ';
    switch (date.month) {
      case 1:
        result += 'jan';
      case 2:
        result += 'fev';
      case 3:
        result += 'mar';
      case 4:
        result += 'abr';
      case 5:
        result += 'mai';
      case 6:
        result += 'jun';
      case 7:
        result += 'jul';
      case 8:
        result += 'ago';
      case 9:
        result += 'set';
      case 10:
        result += 'out';
      case 11:
        result += 'nov';
      case 12:
        result += 'dez';
    }
    return result;
  }

  static String formatDateMonthYear(DateTime date) {
    // [Jan/2023]
    String result = '';
    switch (date.month) {
      case 1:
        result += 'Jan';
      case 2:
        result += 'Fev';
      case 3:
        result += 'Mar';
      case 4:
        result += 'Abr';
      case 5:
        result += 'Mai';
      case 6:
        result += 'Jun';
      case 7:
        result += 'Jul';
      case 8:
        result += 'Ago';
      case 9:
        result += 'Set';
      case 10:
        result += 'Out';
      case 11:
        result += 'Nov';
      case 12:
        result += 'Dez';
    }
    return '$result ${date.year}';
  }

  static String formatDateDayMonthYear(DateTime date) {
    // [12/Mar/1996]
    String result = '${formatNumber(date.day)}/';
    switch (date.month) {
      case 1:
        result += 'Jan';
      case 2:
        result += 'Fev';
      case 3:
        result += 'Mar';
      case 4:
        result += 'Abr';
      case 5:
        result += 'Mai';
      case 6:
        result += 'Jun';
      case 7:
        result += 'Jul';
      case 8:
        result += 'Ago';
      case 9:
        result += 'Set';
      case 10:
        result += 'Out';
      case 11:
        result += 'Nov';
      case 12:
        result += 'Dez';
    }
    return '$result ${date.year}';
  }

  static String formatDateMouthHour(DateTime date) {
    // [10 de jan às 20:05]
    return '${formatDateMonth(date)} às ${formatHourMinute(date)}';
  }

  static String formatDateMouthHourMG(DateTime date) {
    // [10 de jan. 20:05]
    return '${formatDateMonth(date)}. ${formatHourMinute(date)}';
  }

  static String formatHourMinuteSeconds(DateTime date) {
    // [20:05:10]
    return '${formatNumber(date.hour)}:${formatNumber(date.minute)}:${formatNumber(date.second)}';
  }

  static String formatHourMinute(DateTime date) {
    // [20:05]
    return '${formatNumber(date.hour)}:${formatNumber(date.minute)}';
  }

  static String formatSeconds(DateTime date) {
    // [10]
    return formatNumber(date.second);
  }

  static String formatDate(DateTime date) {
    // [12/03/1996]
    return '${formatNumber(date.day)}/${formatNumber(date.month)}/${date.year}';
  }

  static String formatDateWithTime(DateTime date) {
    // [12/03/1996 20:05]
    return '${formatDate(date)} ${formatHourMinute(date)}';
  }

  static String formatDateEUA(DateTime date) {
    // [1996/03/12]
    return '${formatNumber(date.year)}/${formatNumber(date.month)}/${date.day}';
  }

  static String formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }

  static String timeFormat(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}min ${duration.inSeconds - duration.inMinutes * 60}s';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ${duration.inMinutes - duration.inHours * 60}min ${duration.inSeconds - duration.inMinutes * 60}s';
    } else {
      return '${duration.inDays} dias ${duration.inHours - duration.inDays * 24}h ${duration.inMinutes - duration.inHours * 60}min ${duration.inSeconds - duration.inMinutes * 60}s';
    }
  }

  static String formatDateToPDF(DateTime date) {
    // [12-03-1996-10h-50min]
    return '${formatNumber(date.day)}-${formatNumber(date.month)}-${date.year}-${formatNumber(date.hour)}h-${formatNumber(date.minute)}min';
  }

  static String getWeekDay(DateTime date) {
    return DateFormat('EEEE', 'pt-BR').format(date).capitalize ?? '';
  }
}
