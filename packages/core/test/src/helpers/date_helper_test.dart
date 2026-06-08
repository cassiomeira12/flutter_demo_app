import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime.now());
    // Inicializa o locale para os testes de getWeekDay
    initializeDateFormatting('pt_BR');
  });

  group('DateHelper.parse - Sucesso', () {
    test(
      'deve retornar DateTime convertido para local quando string valida',
      () {
        // arrange
        const dateString = '2024-01-15T10:30:00.000Z';

        // act
        final result = DateHelper.parse(dateString);

        // assert
        expect(result, isA<DateTime>());
        expect(result.year, 2024);
      },
    );

    test('deve converter data ISO 8601 corretamente', () {
      // arrange
      const dateString = '2023-12-25T20:00:00.000Z';

      // act
      final result = DateHelper.parse(dateString);

      // assert
      expect(result, isA<DateTime>());
      expect(result.year, 2023);
      expect(result.month, 12);
      expect(result.day, 25);
    });
  });

  group('DateHelper.parse - Erro', () {
    test('deve lanc ar FormatException quando string invalida', () {
      // arrange
      const invalidDateString = 'nao-e-uma-data';

      // act & assert
      expect(
        () => DateHelper.parse(invalidDateString),
        throwsA(isA<FormatException>()),
      );
    });

    test('deve lanc ar FormatException quando string vazia', () {
      // arrange
      const emptyDateString = '';

      // act & assert
      expect(
        () => DateHelper.parse(emptyDateString),
        throwsA(isA<FormatException>()),
      );
    });

    test('deve lanc ar FormatException quando formato invalido', () {
      // arrange
      const invalidFormat = '15/01/2024';

      // act & assert
      expect(
        () => DateHelper.parse(invalidFormat),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('DateHelper.getTimeToNow - Sucesso', () {
    test('deve retornar segundos quando diff < 60 segundos', () {
      // arrange
      final date = DateTime.now().subtract(const Duration(seconds: 30));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, contains('s'));
    });

    test('deve retornar minutos quando diff < 60 minutos', () {
      // arrange
      final date = DateTime.now().subtract(const Duration(minutes: 30));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, contains('m'));
    });

    test('deve retornar horas quando diff < 24 horas', () {
      // arrange
      final date = DateTime.now().subtract(const Duration(hours: 5));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, contains('h'));
    });

    test('deve retornar dias quando diff < 365 dias', () {
      // arrange
      final date = DateTime.now().subtract(const Duration(days: 50));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, contains('d'));
    });

    test('deve retornar anos quando diff >= 365 dias', () {
      // arrange
      final date = DateTime.now().subtract(const Duration(days: 400));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, contains('a'));
    });
  });

  group('DateHelper.getTimeToNow - Erro', () {
    test('deve lidar com data futura (diff negativa)', () {
      // arrange - data no futuro
      final date = DateTime.now().add(const Duration(hours: 1));

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert - deve retornar valor negativo ou formato diferente
      expect(result, isA<String>());
    });

    test('deve lidar com DateTime no limite (0 segundos)', () {
      // arrange
      final date = DateTime.now();

      // act
      final result = DateHelper.getTimeToNow(date);

      // assert
      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });
  });

  group('DateHelper.getTimeFromNow - Sucesso', () {
    test('deve retornar dias quando diff < 30 dias', () {
      // arrange
      final date = DateTime.now().add(const Duration(days: 15));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, contains('dias'));
    });

    test('deve retornar "mês" quando diff entre 30 e 60 dias', () {
      // arrange
      final date = DateTime.now().add(const Duration(days: 45));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, contains('mês'));
    });

    test('deve retornar "meses" quando diff entre 60 e 365 dias', () {
      // arrange
      final date = DateTime.now().add(const Duration(days: 120));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, contains('meses'));
    });

    test('deve retornar "ano" quando diff entre 365 e 730 dias', () {
      // arrange
      final date = DateTime.now().add(const Duration(days: 400));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, contains('ano'));
    });

    test('deve retornar "anos" quando diff >= 730 dias', () {
      // arrange
      final date = DateTime.now().add(const Duration(days: 800));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, contains('anos'));
    });
  });

  group('DateHelper.getTimeFromNow - Erro', () {
    test('deve lidar com data no passado', () {
      // arrange - data no passado
      final date = DateTime.now().subtract(const Duration(days: 10));

      // act
      final result = DateHelper.getTimeFromNow(date);

      // assert
      expect(result, isA<String>());
    });
  });

  group('DateHelper.formatDateMonth - Sucesso', () {
    test('deve formatar janeiro corretamente', () {
      // arrange
      final date = DateTime(2024, 1, 15);

      // act
      final result = DateHelper.formatDateMonth(date);

      // assert
      expect(result, contains('15'));
      expect(result, contains('jan'));
    });

    test('deve formatar dezembro corretamente', () {
      // arrange
      final date = DateTime(2024, 12, 25);

      // act
      final result = DateHelper.formatDateMonth(date);

      // assert
      expect(result, contains('25'));
      expect(result, contains('dez'));
    });

    test('deve formatar todos os meses do ano', () {
      // arrange & act & assert
      final months = [
        ('jan', 1),
        ('fev', 2),
        ('mar', 3),
        ('abr', 4),
        ('mai', 5),
        ('jun', 6),
        ('jul', 7),
        ('ago', 8),
        ('set', 9),
        ('out', 10),
        ('nov', 11),
        ('dez', 12),
      ];

      for (final (monthName, monthNumber) in months) {
        final date = DateTime(2024, monthNumber, 10);
        final result = DateHelper.formatDateMonth(date);
        expect(
          result,
          contains(monthName),
          reason: 'Month $monthNumber should contain $monthName',
        );
      }
    });
  });

  group('DateHelper.formatDateMonthYear - Sucesso', () {
    test('deve formatar mes e ano corretamente', () {
      // arrange
      final date = DateTime(2023, 3, 15);

      // act
      final result = DateHelper.formatDateMonthYear(date);

      // assert
      expect(result, contains('Mar'));
      expect(result, contains('2023'));
    });

    test('deve formatar dezembro com ano', () {
      // arrange
      final date = DateTime(2024, 12);

      // act
      final result = DateHelper.formatDateMonthYear(date);

      // assert
      expect(result, contains('Dez'));
      expect(result, contains('2024'));
    });
  });

  group('DateHelper.formatDateDayMonthYear - Sucesso', () {
    test('deve formatar dia, mes e ano corretamente', () {
      // arrange
      final date = DateTime(1996, 3, 12);

      // act
      final result = DateHelper.formatDateDayMonthYear(date);

      // assert
      expect(result, contains('12'));
      expect(result, contains('Mar'));
      expect(result, contains('1996'));
    });

    test('deve adicionar zero a esquerda para dias menores que 10', () {
      // arrange
      final date = DateTime(2024, 1, 5);

      // act
      final result = DateHelper.formatDateDayMonthYear(date);

      // assert
      expect(result, contains('05'));
    });
  });

  group('DateHelper.formatDateMouthHour - Sucesso', () {
    test('deve formatar data com hora corretamente', () {
      // arrange
      final date = DateTime(2024, 1, 10, 20, 5);

      // act
      final result = DateHelper.formatDateMouthHour(date);

      // assert
      expect(result, contains('10'));
      expect(result, contains('jan'));
      expect(result, contains('20'));
      expect(result, contains('05'));
    });
  });

  group('DateHelper.formatHourMinute - Sucesso', () {
    test('deve formatar hora e minuto corretamente', () {
      // arrange
      final date = DateTime(2024, 1, 1, 14, 30);

      // act
      final result = DateHelper.formatHourMinute(date);

      // assert
      expect(result, '14:30');
    });

    test('deve adicionar zero a esquerda para hora < 10', () {
      // arrange
      final date = DateTime(2024, 1, 1, 8, 5);

      // act
      final result = DateHelper.formatHourMinute(date);

      // assert
      expect(result, '08:05');
    });
  });

  group('DateHelper.formatHourMinuteSeconds - Sucesso', () {
    test('deve formatar hora, minuto e segundo corretamente', () {
      // arrange
      final date = DateTime(2024, 1, 1, 20, 5, 10);

      // act
      final result = DateHelper.formatHourMinuteSeconds(date);

      // assert
      expect(result, '20:05:10');
    });

    test('deve adicionar zeros a esquerda para valores < 10', () {
      // arrange
      final date = DateTime(2024, 1, 1, 1, 2, 3);

      // act
      final result = DateHelper.formatHourMinuteSeconds(date);

      // assert
      expect(result, '01:02:03');
    });
  });

  group('DateHelper.formatDate - Sucesso', () {
    test('deve formatar data em formato brasileiro', () {
      // arrange
      final date = DateTime(1996, 3, 12);

      // act
      final result = DateHelper.formatDate(date);

      // assert
      expect(result, '12/03/1996');
    });

    test('deve adicionar zeros para dia e mes < 10', () {
      // arrange
      final date = DateTime(2024, 1, 5);

      // act
      final result = DateHelper.formatDate(date);

      // assert
      expect(result, '05/01/2024');
    });
  });

  group('DateHelper.formatDateWithTime - Sucesso', () {
    test('deve formatar data com hora', () {
      // arrange
      final date = DateTime(2024, 1, 15, 14, 30);

      // act
      final result = DateHelper.formatDateWithTime(date);

      // assert
      expect(result, contains('15/01/2024'));
      expect(result, contains('14:30'));
    });
  });

  group('DateHelper.formatDateEUA - Sucesso', () {
    test('deve formatar data em formato EUA', () {
      // arrange
      final date = DateTime(1996, 3, 12);

      // act
      final result = DateHelper.formatDateEUA(date);

      // assert
      expect(result, '1996/03/12');
    });
  });

  group('DateHelper.formatNumber - Sucesso', () {
    test('deve adicionar zero a esquerda para numeros < 10', () {
      // arrange
      const number = 5;

      // act
      final result = DateHelper.formatNumber(number);

      // assert
      expect(result, '05');
    });

    test('deve manter numero sem zero para numeros >= 10', () {
      // arrange
      const number = 12;

      // act
      final result = DateHelper.formatNumber(number);

      // assert
      expect(result, '12');
    });

    test('deve formatar zero corretamente', () {
      // arrange
      const number = 0;

      // act
      final result = DateHelper.formatNumber(number);

      // assert
      expect(result, '00');
    });
  });

  group('DateHelper.formatNumber - Erro', () {
    test('deve lidar com numeros de dois digitos', () {
      // arrange
      const number = 99;

      // act
      final result = DateHelper.formatNumber(number);

      // assert
      expect(result, '99');
    });
  });

  group('DateHelper.timeFormat - Sucesso', () {
    test('deve formatar segundos corretamente', () {
      // arrange
      const duration = Duration(seconds: 45);

      // act
      final result = DateHelper.timeFormat(duration);

      // assert
      expect(result, contains('45s'));
    });

    test('deve formatar minutos e segundos corretamente', () {
      // arrange
      const duration = Duration(minutes: 5, seconds: 30);

      // act
      final result = DateHelper.timeFormat(duration);

      // assert
      expect(result, contains('5min'));
      expect(result, contains('30s'));
    });

    test('deve formatar horas, minutos e segundos corretamente', () {
      // arrange
      const duration = Duration(hours: 2, minutes: 15, seconds: 45);

      // act
      final result = DateHelper.timeFormat(duration);

      // assert
      expect(result, contains('2h'));
      expect(result, contains('15min'));
      expect(result, contains('45s'));
    });

    test('deve formatar dias, horas, minutos e segundos corretamente', () {
      // arrange
      const duration = Duration(days: 1, hours: 3, minutes: 30, seconds: 15);

      // act
      final result = DateHelper.timeFormat(duration);

      // assert
      expect(result, contains('1 dias'));
      expect(result, contains('3h'));
      expect(result, contains('30min'));
      expect(result, contains('15s'));
    });
  });

  group('DateHelper.timeFormat - Erro', () {
    test('deve lidar com duracao zero', () {
      // arrange
      const duration = Duration.zero;

      // act
      final result = DateHelper.timeFormat(duration);

      // assert
      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });
  });

  group('DateHelper.formatDateToPDF - Sucesso', () {
    test('deve formatar data para PDF corretamente', () {
      // arrange
      final date = DateTime(1996, 3, 12, 10, 50);

      // act
      final result = DateHelper.formatDateToPDF(date);

      // assert
      expect(result, contains('12-03-1996'));
      expect(result, contains('10h'));
      expect(result, contains('50min'));
    });
  });

  group('DateHelper.getWeekDay - Sucesso', () {
    test('deve retornar dia da semana em portugues', () {
      // arrange
      final date = DateTime(2024, 1, 15); // segunda-feira

      // act
      final result = DateHelper.getWeekDay(date);

      // assert
      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });

    test('deve formatar diferentes dias da semana', () {
      // arrange
      final monday = DateTime(2024, 1, 15);
      final friday = DateTime(2024, 1, 19);

      // act
      final mondayResult = DateHelper.getWeekDay(monday);
      final fridayResult = DateHelper.getWeekDay(friday);

      // assert
      expect(mondayResult, isA<String>());
      expect(fridayResult, isA<String>());
    });
  });

  group('DateHelper.getWeekDay - Erro', () {
    test('deve lidar com DateTime invalido', () {
      // arrange - data muito antiga ou invalida
      final date = DateTime(1);

      // act
      final result = DateHelper.getWeekDay(date);

      // assert - deve retornar string vazia ou valor padrao
      expect(result, isA<String>());
    });
  });

  group('DateHelper.formatSeconds - Sucesso', () {
    test('deve formatar segundos corretamente', () {
      // arrange
      final date = DateTime(2024, 1, 1, 1, 1, 45);

      // act
      final result = DateHelper.formatSeconds(date);

      // assert
      expect(result, '45');
    });

    test('deve adicionar zero para segundos < 10', () {
      // arrange
      final date = DateTime(2024, 1, 1, 1, 1, 5);

      // act
      final result = DateHelper.formatSeconds(date);

      // assert
      expect(result, '05');
    });
  });

  group('DateHelper.formatDateMouthHourMG - Sucesso', () {
    test('deve formatar data no formato brasileiro minusculo', () {
      // arrange
      final date = DateTime(2024, 1, 10, 20, 5);

      // act
      final result = DateHelper.formatDateMouthHourMG(date);

      // assert
      expect(result, contains('10'));
      expect(result, contains('jan'));
      expect(result, contains('20:05'));
    });
  });

  group('Edge Cases', () {
    test('deve lidar com datas em limites de ano bissexto', () {
      // arrange - ano bissexto
      final date = DateTime(2024, 2, 29, 23, 59, 59);

      // act
      final formattedDate = DateHelper.formatDate(date);
      final formattedDateTime = DateHelper.formatDateWithTime(date);

      // assert
      expect(formattedDate, isNotEmpty);
      expect(formattedDateTime, isNotEmpty);
    });

    test('deve lidar com ano novo', () {
      // arrange
      final date = DateTime(2025);

      // act
      final result = DateHelper.formatDate(date);
      final monthYear = DateHelper.formatDateMonthYear(date);

      // assert
      expect(result, '01/01/2025');
      expect(monthYear, contains('2025'));
    });

    test('deve lidar com midnight', () {
      // arrange
      final date = DateTime(2024, 6, 15);

      // act
      final result = DateHelper.formatHourMinute(date);

      // assert
      expect(result, '00:00');
    });
  });
}
