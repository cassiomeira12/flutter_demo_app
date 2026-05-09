Feature: Work Point
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas
    And O aplicativo está atualizado
    And O aplicativo é inicializado
    And O usuário loga na conta padrão
    Given O aplicativo está na rota {'/check_points'}
    And A tela de checkpoints é validada

  Scenario: Registrar ponto
    When O usuário clica no componente da key {'register_check_point_key'}
    And O usuário clica em {'Continuar'}
    Then O usuario valida que o ponto foi efetuado
    When O usuario clica na data de hoje
    And O aplicativo está na rota {'/check_points/check_point'}
    Then A tela de checkpoint é validada

  Scenario: Registrar ponto de um dia
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuário clica no componente da key {'register_check_point_key'}
    And O usuário seleciona o horário {'08:30'}
    And O usuário clica em {'Continuar'}
    Then O usuario valida que o ponto foi efetuado no horario {'08:30'}
    When O usuário volta a tela
    Then O aplicativo está na rota {'/check_points/check_point'}

  Scenario: Editar ponto no dia
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuario altera o ponto das {'08:30'}
    And O usuário seleciona o horário {'09:30'}
    And O usuário clica em {'Continuar'}
    Then O usuario valida que o ponto foi efetuado no horario {'09:30'}
    When O usuário volta a tela
    Then O aplicativo está na rota {'/check_points/check_point'}

  Scenario: Remover ponto no dia
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuario remove o ponto das {'09:30'}
    And O usuário clica em {'Continuar'}
    Then O usuário não vizualizao ponto {'09:30'}
    When O usuário volta a tela
    Then O aplicativo está na rota {'/check_points/check_point'}

  Scenario: Marcar dia como feriado
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuário clica no componente da key {'popup_menu_key'}
    Then O popup é validado
    When O usuário clica em {'Marcar dia como feriado'}
    Then Validar popup de justificativa
    And O usuário digita {'Justificativa de feriado'} no campo {'justification_input_key'}
    And O usuário clica em {'Salvar'}
    Then O checkpoint está marcado feriado {'Sim'}

  Scenario: Marcar dia como abono
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuário clica no componente da key {'popup_menu_key'}
    Then O popup é validado
    When O usuário clica em {'Marcar dia como abono'}
    Then Validar popup de justificativa
    And O usuário digita {'Justificativa de abono'} no campo {'justification_input_key'}
    And O usuário clica em {'Salvar'}
    Then O checkpoint está marcado feriado {'Sim'}

  Scenario: Marcar dia como folga
    When O usuario clica na data de hoje
    Then O aplicativo está na rota {'/check_points/check_point'}
    When O usuário clica no componente da key {'popup_menu_key'}
    Then O popup é validado
    When O usuário clica em {'Marcar dia como folga'}
    Then Validar popup de justificativa
    And O usuário digita {'Justificativa de folga'} no campo {'justification_input_key'}
    And O usuário clica em {'Salvar'}
    Then O checkpoint está marcado feriado {'Sim'}
