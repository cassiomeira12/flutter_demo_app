Feature: Settings
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And O aplicativo está atualizado
    And O aplicativo é inicializado
    And O usuário loga na conta padrão
    And O usuário abre a aba de configurações

  Scenario: Validar tela de configurações
    Given O aplicativo está na rota {'/settings'}
    And A tela de settings é validada

    When O usuário clica em {'Meus dados'}
    Then Validar tela de dados do usuário
    And O usuário volta a tela

    When O usuário clica em {'Segurança'}
    Then Validar tela de segurança
    And O usuário volta a tela

    When O usuário clica em {'Idioma'}
    Then Validar dialog de idiomas
    And O usuário fecha o bottom sheet

    When O usuário clica em {'Temas'}
    Then Validar tela de temas
    When O usuário clica em {'Tema'}
    And Validar dialog de temas
    And O usuário fecha o bottom sheet
    And O usuário volta a tela

    When O usuário clica em {'Sobre'}
    Then Validar tela de sobre
    And O usuário volta a tela

    When O usuário clica em {'Limpar cache do aplicativo'}
    Then Validar dialog de limpar cache do aplicativo
    And O usuário fecha o bottom sheet

    And O usuário faz o logout
