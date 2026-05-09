Feature: Password Manager
  Background:
    Given O app está recém instalado
    And O app está com intro concluída
    And As permissões foram aceitas
    And O aplicativo está atualizado
    And O aplicativo é inicializado
    Given O usuário loga na conta padrão

  Scenario: Criar, visualizar e remover uma senha
    Given O usuário clica no componente da key {'add_new_credential_button_key'}
    And O aplicativo está na rota {'/credentials/credential'}

    When O usuário digita {'NovaSenha'} no campo {'credential_name_input_key'}
    And O usuário digita {'Usuario'} no campo {'username_input_key'}
    And O usuário digita {'Senha'} no campo {'password_input_key'}
    And O usuário clica no componente da key {'save_credential_button_key'}

    Then O aplicativo está na rota {'/credentials'}
    And O usuário ver a mensagem {'NovaSenha'}

    When O usuário clica em {'NovaSenha'}
    And O usuário clica no componente da key {'popup_menu_key'}
    And O usuário clica em {'Remover'}
    Then O usuário não ver a mensagem {'NovaSenha'}

    And O usuário faz o logout

  Scenario: Editar uma senha existente
    Given O usuário clica no componente da key {'add_new_credential_button_key'}
    And O aplicativo está na rota {'/credentials/credential'}

    When O usuário digita {'SenhaEditavel'} no campo {'credential_name_input_key'}
    And O usuário digita {'Usuario'} no campo {'username_input_key'}
    And O usuário digita {'Senha'} no campo {'password_input_key'}
    And O usuário clica no componente da key {'save_credential_button_key'}

    Then O aplicativo está na rota {'/credentials'}
    And O usuário ver a mensagem {'SenhaEditavel'}

    When O usuário clica em {'SenhaEditavel'}
    And O usuário digita {'SenhaEditada'} no campo {'credential_name_input_key'}
    And O usuário digita {'UsuarioEditado'} no campo {'username_input_key'}
    And O usuário digita {'SenhaEditada'} no campo {'password_input_key'}
    And O usuário clica no componente da key {'save_credential_button_key'}

    Then O aplicativo está na rota {'/credentials'}
    And O usuário ver a mensagem {'SenhaEditada'}
    And O usuário não ver a mensagem {'SenhaEditavel'}

    When O usuário clica em {'SenhaEditada'}
    And O usuário clica no componente da key {'popup_menu_key'}
    And O usuário clica em {'Remover'}
    Then O usuário não ver a mensagem {'SenhaEditavel'}

    And O usuário faz o logout
