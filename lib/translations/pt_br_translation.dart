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
        'allowance': 'Abono',
        'day_off': 'Folga',
        'weekend': 'Final de semana',
        'total_hours': 'Total de horas',
        'total_budget': 'Faturamento',
        'make_check_point': 'Bater ponto',
        'make_check_point_now': 'Deseja bater ponto agora?',
        'empty_check_point_list': 'Você ainda não registrou nenhum ponto',
        'date': 'Data',
        'has_inconsistency': 'Possui inconsistência',
        'delete_check_point': 'Deletar ponto',
        'delete_check_point_selected':
            'Deseja deletar o ponto {checkHourPoint}h ?',
        'check_point': 'Ponto',
        'set_to_holiday': 'Marcar dia como feriado',
        'set_to_allowance': 'Marcar dia como abono',
        'set_to_day_off': 'Marcar dia como folga',
        'work_point_already_created':
            'Seu ponto já foi registrado às {hourPoint}h',
        'justification': 'Justificativa',
        'justification_hint': 'Digite uma justificativa',
      },
    };
  }
}
