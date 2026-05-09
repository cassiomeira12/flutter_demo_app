Feature: Change password
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas
    And O aplicativo está atualizado

  Scenario: Validar inputs inválidos
    Given O aplicativo é inicializado
    And O usuário loga na conta padrão
    When O usuário abre a aba de configurações
    And O usuário clica em {'Meus dados'}
    And O usuário clica em {'Alterar senha'}
    Then O aplicativo está na rota {'/settings/user/change_password'}
    And A tela de change password é validada

    When O usuário digita {' '} no campo {'password_input_key'}
    And O usuário digita {'123456'} no campo {'new_password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    And O usuário clica em {'Salvar'}
    Then O usuário ver a mensagem {'Digite sua senha'}

    When O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {' '} no campo {'new_password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    And O usuário clica em {'Salvar'}
    Then O usuário ver a mensagem {'Digite sua senha'}

    When O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {'123456'} no campo {'new_password_input_key'}
    And O usuário digita {' '} no campo {'confirm_password_input_key'}
    And O usuário clica em {'Salvar'}
    Then O usuário ver a mensagem {'Digite sua senha'}

    When O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {'123456'} no campo {'new_password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    And O usuário clica em {'Salvar'}
    Then O usuário ver a mensagem {'A nova senha não pode ser igual a atual'}

    When O usuário digita {'123456'} no campo {'password_input_key'}
    And O usuário digita {'abcde'} no campo {'new_password_input_key'}
    And O usuário digita {'123456'} no campo {'confirm_password_input_key'}
    And O usuário clica em {'Salvar'}
    Then O usuário ver a mensagem {'As senhas não são iguais'}

    And O usuário volta a tela
    And O aplicativo está na rota {'/settings/user'}
    And O usuário volta a tela

    And O usuário faz o logout

  Scenario Outline: Altera a senha do usuário
    Given O aplicativo é inicializado
    And O usuário loga com username <username> e senha <atualSenha>
    When O usuário abre a aba de configurações
    And O usuário clica em {'Meus dados'}
    And O usuário clica em {'Alterar senha'}
    Then O aplicativo está na rota {'/settings/user/change_password'}
    And A tela de change password é validada

    When O usuário digita <atualSenha> no campo {'password_input_key'}
    And O usuário digita <novaSenha> no campo {'new_password_input_key'}
    And O usuário digita <confirmarSenha> no campo {'confirm_password_input_key'}

    And O usuário clica em {'Salvar'}
    Then O usuário ver mensagem de sucesso
    And O usuário fecha o dialog

    And O aplicativo está na rota {'/settings/user'}
    And O usuário volta a tela
    And O usuário faz o logout

    When O aplicativo está na rota {'/login'}
    And O usuário loga com username <username> e senha <novaSenha>
    And O usuário faz o logout

    Examples:
      | username          | atualSenha | novaSenha | confirmarSenha |
      | 'teste@email.com' | '123456'   | '1234567' | '1234567'      |
      | 'teste@email.com' | '1234567'  | '123456'  | '123456'       |
