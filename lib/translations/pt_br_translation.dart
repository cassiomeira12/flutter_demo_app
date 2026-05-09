import 'package:core/core.dart';

class AppPtBrTranslation extends PtBrTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app':
            'Um aplicativo simples e eficiente para registrar o ponto de trabalho de forma rápida e segura. Controle entradas, saídas e pausas em tempo real, acompanhe sua jornada e mantenha seu histórico sempre organizado.',
        'remember_my_credentials': 'Salvar minhas credenciais',
        'change_month': 'Alterar mês',
        'holiday': 'Feriado',
        'weekend': 'Final de semana',
        'total_hours': 'Total de horas',
        'total_budget': 'Faturamento',
        'make_check_point': 'Bater ponto',
        'make_check_point_now': 'Deseja bater ponto agora?',
        'empty_check_point_list': 'Você ainda não registrou nenhum ponto',
      },
    };
  }
}
