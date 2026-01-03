import 'package:core/core.dart';

class AppPtBrTranslation extends PtBrTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'remember_my_credentials': 'Salvar minhas credenciais',
        'change_month': 'Alterar mês',
        'holiday': 'Feriado',
        'weekend': 'Final de semana',
        'total_hours': 'Total de horas',
        'total_budget': 'Faturamento',
        'make_check_point': 'Bater ponto',
        'make_check_point_now': 'Deseja bater ponto agora?',
      },
    };
  }
}
