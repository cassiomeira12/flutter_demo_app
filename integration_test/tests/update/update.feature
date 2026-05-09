Feature: Update App
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas

  Scenario: Validar atualização disponível não bloqueante
    When O aplicativo possui uma atualização não bloqueante
    And O aplicativo é inicializado
    And O usuario espera {1} segundos
    Then O aplicativo está na rota {'/update'}
    And A tela de update available é validada
    And O usuario espera {1} segundos
    When O usuário clica no componente da key {'update_later_button_key'}
    Then O aplicativo não está na rota {'/update'}
    And O usuario espera {1} segundos

  Scenario: Validar atualização disponível bloqueante
    When O aplicativo possui uma atualização bloqueante
    And O aplicativo é inicializado
    And O usuario espera {1} segundos
    Then O aplicativo está na rota {'/force_update'}
    Then A tela de force update é validada
    And O usuario espera {1} segundos
