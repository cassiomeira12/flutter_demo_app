Feature: Signup
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas
    And O aplicativo está atualizado
    And O aplicativo é inicializado
    When O aplicativo está na rota {'/login'}
    Then O usuário clica em {'Criar uma conta'}
    Given O aplicativo está na rota {'/signup'}
    And A tela de signup é validada

  Scenario: Validar aceite de termos
    When O usuário digita {'Faker'} no campo {'name_input_key'}
    And O usuário digita {'faker@email.com'} no campo {'email_input_key'}
    And O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    And O usuário clica no componente da key {'signup_button_key'}
    Then O usuário ver a mensagem {'Você precisa aceitar os termos e a política de privacidade'}

  Scenario Outline: Validar inputs inválidos
    When O usuário digita <nome> no campo {'name_input_key'}
    And O usuário digita <email> no campo {'email_input_key'}
    And O usuário digita <senha> no campo {'password_input_key'}
    And O usuário digita <confirmarSenha> no campo {'confirm_password_input_key'}

    And O usuário clica no componente da key {'signup_button_key'}

    Then O usuário ver a mensagem <mensagemNome>
    Then O usuário ver a mensagem <mensagemEmail>
    Then O usuário ver a mensagem <mensagemSenha>
    Then O usuário ver a mensagem <mensagemConfirmaSenha>

    Examples:
      | nome    | email             | senha    | confirmarSenha | mensagemNome      | mensagemEmail             | mensagemSenha      | mensagemConfirmaSenha      |
      | ' '     | ' '               | ' '      | '1'            | 'Digite seu nome' | 'Digite seu e-mail'       | 'Digite sua senha' | 'As senhas não são iguais' |
      | 'Teste' | 'teste.com'       | '123456' | ' '            | ''                | 'Digite um e-mail válido' | ''                 | 'Digite sua senha'         |
      | 'Teste' | 'teste@email.com' | '123456' | '123456'       | ''                | ''                        | ''                 | ''                         |

  Scenario: Criar conta de usuário e depois deletar conta
    When O usuário digita {'Faker'} no campo {'name_input_key'}
    And O usuário digita {'faker@email.com'} no campo {'email_input_key'}
    And O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    When O usuário clica no componente da key {'accept_terms_and_policy_checkbox_widget_key'}
    And O usuário clica no componente da key {'signup_button_key'}
    And O usuário deleta a sua conta com username {'fake@email.com'} e senha {'123456'}
