Feature: Intro
  Background:
    Given O app está recém instalado

  Scenario: Validar páginas de intro sem permissões
    Given O aplicativo não possui permissões
    And O aplicativo é inicializado
    When O aplicativo está na rota {'/intro'}
    Then A tela de intro default é validada
    And O usuário não ver a mensagem {'Voltar'}
    And O usuário não ver a mensagem {'Próximo'}
    And O usuário ver a mensagem {'Concluir'}
    And O usuário clica no componente da key {'finish_intro_button_key'}
    Then O aplicativo não está na rota {'/intro'}

  Scenario Outline: Validar páginas de intro no Android
    Given O aplicativo simula a plataform {'android'}
    And O aplicativo possui as persmissões <permission>
    And O aplicativo é inicializado
    When O aplicativo está na rota {'/intro'}
    Then A tela de intro default é validada
    And O usuário não ver a mensagem {'Voltar'}
    When O usuário valida a permissão <permission> na plataforma {'android'} com title <title> e message <message>
    Then O aplicativo não está na rota {'/intro'}

    Examples:
      | permission                | title                      | message                   |
      | 'appTrackingTransparency' | 'title_intro_app_tracking' | 'body_intro_app_tracking' |
      | 'notification'            | 'title_intro_notification' | 'body_intro_notification' |
      | 'location'                | 'title_intro_location'     | 'body_intro_location'     |

  Scenario Outline: Validar páginas de intro no iOS
    Given O aplicativo simula a plataform {'iOS'}
    And O aplicativo possui as persmissões <permission>
    And O aplicativo é inicializado
    When O aplicativo está na rota {'/intro'}
    Then A tela de intro default é validada
    And O usuário não ver a mensagem {'Voltar'}
    When O usuário valida a permissão <permission> na plataforma {'iOS'} com title <title> e message <message>
    Then O aplicativo não está na rota {'/intro'}

    Examples:
      | permission                | title                      | message                   |
      | 'appTrackingTransparency' | 'title_intro_app_tracking' | 'body_intro_app_tracking' |
      | 'notification'            | 'title_intro_notification' | 'body_intro_notification' |
      | 'location'                | 'title_intro_location'     | 'body_intro_location'     |

  Scenario Outline: Validar páginas de intro no macOS
    Given O aplicativo simula a plataform {'macOS'}
    And O aplicativo possui as persmissões <permission>
    And O aplicativo é inicializado
    When O aplicativo está na rota {'/intro'}
    Then A tela de intro default é validada
    And O usuário não ver a mensagem {'Voltar'}
    When O usuário valida a permissão <permission> na plataforma {'macOS'} com title <title> e message <message>
    Then O aplicativo não está na rota {'/intro'}

    Examples:
      | permission                | title                      | message                   |
      | 'appTrackingTransparency' | 'title_intro_app_tracking' | 'body_intro_app_tracking' |
      | 'notification'            | 'title_intro_notification' | 'body_intro_notification' |
      | 'location'                | 'title_intro_location'     | 'body_intro_location'     |
