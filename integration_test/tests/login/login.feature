Feature: Login
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas
    And O aplicativo está atualizado
    And O aplicativo é inicializado
    Given O aplicativo está na rota {'/login'}
    And A tela de login é validada

  Scenario Outline: Validar inputs inválidos
    When O usuário digita <username> no campo {'username_input_key'}
    And O usuário digita <senha> no campo {'password_input_key'}

    And O usuário clica no componente da key {'login_button_key'}

    Then O usuário ver a mensagem <mensagemUsername>
    Then O usuário ver a mensagem <mensagemSenha>

    Examples:
      | username         | senha    | mensagemUsername                      | mensagemSenha      |
      | ' '              | ' '      | 'Digite seu e-mail'                   | 'Digite sua senha' |
      | 'fake.com'       | '123456' | 'Digite um e-mail válido'             | ''                 |
      | 'fake@email.com' | '123456' | 'Nome de usuário ou senha incorretos' | 'Ok'               |

  Scenario: Login com sucesso
    When O usuário loga na conta padrão
    And O usuário faz o logout

  Scenario: Fazer login e lembrar meu e-mail
    Given O usuário clica no componente da key {'remember_checkbox_key'}
    And O checkbox {'remember_checkbox_key'} esta com status {true}
    When O usuário loga na conta padrão
    And O usuário faz o logout
    When O aplicativo está na rota {'/login'}
    Then O usuário ver a mensagem {'teste@email.com'}
    And O checkbox {'remember_checkbox_key'} esta com status {true}
    And O usuário clica no componente da key {'remember_checkbox_key'}
    And O checkbox {'remember_checkbox_key'} esta com status {false}
    When O usuário loga na conta padrão
    And O usuário faz o logout
    When O aplicativo está na rota {'/login'}
    Then O usuário não ver a mensagem {'teste@email.com'}
    And O checkbox {'remember_checkbox_key'} esta com status {false}
