Feature: Blocking App
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas

  Scenario: Validar o App bloqueado
    When O aplicativo está bloqueado
    And O aplicativo é inicializado
    And O usuario espera {1} segundos
    Then O aplicativo está na rota {'/blocking'}
    And A tela de blocking é validada
    And O usuario espera {1} segundos
