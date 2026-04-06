import 'package:dependency/dependency.dart';

class PtBrTranslation extends Translations {
  final String localeName = 'pt_BR';

  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        // Intro
        'back_intro': 'Voltar',
        'next_intro': 'Próximo',
        'finish_intro': 'Concluir',
        'title_intro_app_tracking': 'Permitir rastreamento',
        'body_intro_app_tracking':
            'Autorize o App a acompanhar sua atividade online para uma experiência personalizada.',
        'title_intro_notification': 'Notificações',
        'body_intro_notification':
            'Ativa as notificações e fique por dentro das notícias que realmente importam',
        'title_intro_location': 'Localização',
        'body_intro_location':
            'Autorize o App a acompanhar sua localização para uma experiência personalizada.',
        //
        'system_theme': 'Automático',
        'light_theme': 'Claro',
        'dark_theme': 'Escuro',
        // Defaults
        'default_error': 'Ocorreu um erro, tente novamente',
        'internet_error_connection': 'Verifique sua conexão com a internet',
        'invalid_session_token': 'Sua sessão expirou.',
        'login_again': 'Faça login novamente.',
        'forbidden_access': 'Você não tem permissão para ver este conteúdo.',
        'blocked_legal_reasons':
            'O conteúdo não pode ser exibido por questões judiciais.',
        'content_not_found': 'O conteúdo não foi encontrado.',
        'server_internal_error': 'Ocorreu um erro no servidor.',
        'server_timeout_response': 'O serviço não está respondendo.',
        'server_unavailable_service':
            'O serviço não está disponível neste momento.',
        'continue': 'Continuar',
        'try_again': 'Tentar novamente',
        // Web App
        'welcome_app': 'Bem-vindo ao {appName}',
        'features_web_nav_bar': 'Funcionalidades',
        'download_web_nav_bar': 'Baixar',
        'about_web_nav_bar': 'Sobre',
        'contact_web_nav_bar': 'Contato',
        'about_web_app': 'Sobre nós',
        'contact_web': 'Contato',
        'follow_our_social_media': 'Nos acompanhe também nas redes sociais',
        'sac_help': 'Ajuda e suporte',
        'copyright_web_app': 'Todos os direitos reservados.',
        'features_web_app': 'Funcionalidades',
        'download_app': 'Baixar o App',
        // Login
        'login': 'Login',
        'password_validation': 'Valide sua senha',
        'confirm': 'Confirmar',
        //
        'username_label': 'E-mail',
        'username_input_hint': 'Digite seu e-mail aqui',
        'username_input_empty_error': 'Digite seu e-mail',
        'name_input_empty_error': 'Digite seu nome',
        'email_input_empty_error': 'Digite seu e-mail',
        'email_input_invalid_error': 'Digite um e-mail válido',
        //
        'password_label': 'Senha',
        'password_input_hint': 'Digite sua senha aqui',
        'password_input_empty_error': 'Digite sua senha',
        'password_not_equals_error': 'As senhas não são iguais',
        'url_input_invalid_error': 'Link de Url inválida',
        'secret_otp_invalid': 'Chave de autenticação inválida',
        'otp_code_copied': 'Código {otp_code} copiado!',
        //
        'recovery_password_button': 'Recuperar senha',
        'login_button': 'Entrar',
        //
        'create_new_account': 'Criar uma conta',
        //
        'invalid_username_password': 'Nome de usuário ou senha incorretos',
        'remember_my_email': 'Lembrar meu e-mail',
        // Recovery Password
        'recovery_password': 'Recuperar sua senha',
        'recovery_password_message':
            'Digite o e-mail para recuperar a sua senha',
        'recovery_password_success_title': 'E-mail enviado com sucesso!',
        'recovery_password_success_message':
            'Verifique seu e-mail para recuperar a senha',
        // SignUp
        'account_already_exists_error': 'Já existe uma conta com esse e-mail',
        // Admin
        'users': 'Usuários',
        'admin_user_details': 'Dados do usuário',
        'delete_user_account': 'Apagar conta',
        'user_sessions': 'Sessões do usuário',
        // Home
        'home': 'Início',
        'settings': 'Ajustes',
        // Settings
        'version': 'Versão',
        'my_data': 'Meus dados',
        'language': 'Idioma',
        'theme': 'Tema',
        'change_password': 'Alterar senha',
        'about': 'Sobre',
        'logout': 'Sair',
        'want_to_clear_cache': 'Deseja limpar os dados?',
        'clear_cache': 'Limpar',
        'back': 'Voltar',
        'language_selection': 'Selecione um idioma',
        'choose_theme_app': 'Escolha um tema para o App',
        'history': 'Meu histórico',
        'notifications': 'Notificações',
        'clear_local_cache': 'Limpar cache do aplicativo',
        'open_website': 'Visitar website',
        'delete_my_account': 'Apagar minha conta',
        'delete_account_title': 'Por que você está encerrando sua conta?',
        'delete_account_reason_1': 'Não atende minhas necessidades.',
        'delete_account_reason_2': 'Prefiro não responder.',
        'delete_account_reason_3': 'Não entendi como o produto funciona.',
        'delete_account_reason_4': 'Outro motivo.',
        'finish_my_account': 'Encerrar conta',
        'delete_account_finish_title':
            'Tem certeza de que deseja excluir sua conta?',
        'delete_account_finish_feature_1':
            'Ao encerrar sua conta, você perderá o acesso a diversos recursos do aplicativo, incluindo a possibilidade de salvar e gerenciar suas credenciais.',
        'delete_account_finish_feature_2':
            'Todos os seus dados serão removidos permanentemente e não será possível recuperá-los.',
        'delete_account_finish_feature_3':
            'Essa ação é irreversível.\nDeseja realmente continuar?',
        'not_delete_my_account': 'Não quero encerrar minha conta',
        'warning': 'Atenção!',
        'delete_account_information_title':
            'Ao confirmar o encerramento da sua conta, todos os seus dados serão permanentemente deletados e não poderão ser recuperados. Isso inclui:',
        'delete_account_information_1': '> Informações pessoais;',
        'delete_account_information_2': '> Histórico de uso;',
        'delete_account_information_3':
            '> Todas as credenciais criadas no aplicativo;',
        'delete_account_information_info':
            'Esta ação é irreversível. Certifique-se de que deseja realmente prosseguir antes de confirmar.',
        'delete_account_success':
            'Encerramento da conta\nsolicitado com sucesso',
        'delete_account_success_message':
            'Agradecemos por experimentar nosso App, Esperamos ver você de volta.',
        // Language
        'pt': 'Português',
        'en': 'Inglês',
        // Terms and Policy Privacy
        'terms_conditions': 'Termos de uso',
        'privacy_policy': 'Política de privacidade',
        // Permissions
        'allow': 'Permitir',
        'allow_later': 'Agora não',
        'permission.contacts_title': 'Permissão de contatos',
        'permission.contacts_message':
            'Precisamos acessar sua lista de contatos para uma melhor experiência.',
        'permission.location_title': 'Permissão de localização',
        'permission.location_message':
            'Precisamos acessar sua localização para te oferecer uma melhor experiência.',
        //
        'remove': 'Remover',
        'cancel': 'Cancelar',
        'ok': 'Ok',
        'save': 'Salvar',
        // Notifications Settings
        'notification': 'Notificações',
        'push_enabled': 'ativada',
        'push_disabled': 'desativada',
        'notifications_settings': 'Configurações',
        'allow_push_notifications': 'Permitir notificações',
        'no_push_permissions': 'Sem Permissões',
        'you_need_enabled_push_permissions':
            'Você precisa habilitar as permissões de notificação do aplicativo!',
        'you_will_receive_notifications': 'Você receberá notificações!',
        'push_notifications_disabled':
            'Sua notificação foi desativada\nVocê não receberá mais mensagens!',
        'push_notifications': 'Notificação Push',
        'send_push_notification_test':
            'Uma notificação de teste será enviado para o seu aplicativo.',
        'send_push_test': 'Enviar teste',
        'test_push_send_success_title': 'Teste de notificação enviado',
        'test_push_send_success_message':
            'Um teste push de notificação foi enviado para este dispositivo, em breve você receberá um push de confirmação.',
        'send_push': 'Enviar push',
        // Security
        'security': 'Segurança',
        'biometric': 'Biometria',
        'biometric_enabled': 'Biometria ativada',
        'biometric_disabled': 'Biometria desativada',
        'biometric_message':
            'Com a biometria ativada o App ficará mais seguro e só você poderá acessar o aplicativo.',
        'biometric_not_supported':
            'Infelizmente seu dispositivo não suporta biometria',
        'biometrics_authenticate_message':
            'Utilize sua biometria para desbloquear o aplicativo.',
        'blocked_app': 'Aplicativo Bloqueado',
        'use_biometrics_to_unlock_app':
            'Use a biometria para desbloquear o App',
        'unlock_app': 'Desbloquear',
        'biometrics_success_activated':
            'Sua biometria foi ativada com sucesso!',
        'biometrics_disabled': 'Sua biometria foi desativada',
        'device_not_support_biometrics':
            'Seu dispositivo não possui suporte à biometria.',
        'blur_protect_enabled': 'Proteção de leitura ativada',
        'blur_protect_disabled': 'Proteção de leitura desativada',
        'blur_protect_message':
            'Com a proteção de leitura ativada, o conteúdo ficará ilegível quando o aplicativo não estiver aberto.',
        //
        'logout_app_message': 'Tem certeza que deseja sair da sua conta?',
        // Change Password
        'current_password': 'Senha atual',
        'new_password': 'Nova senha',
        'create_strong_password': 'Crie uma senha forte',
        'repeat_password': 'Repita a senha',
        'repeat_password_hint': 'Repita a nova senha',
        'change_password_success_title': 'Senha alterada',
        'change_password_success_message':
            'Sua senha foi alterada com sucesso!',
        'new_password_not_be_equal_old_password':
            'A nova senha não pode ser igual a atual',
        'confirm_password_not_equal': 'As senhas não são iguais',
        // Signup
        'name': 'Nome',
        'enter_your_full_name': 'Digite seu nome completo',
        'signup': 'Criar conta',
        'fill_the_captcha': 'Preencha o Captcha',
        'generate_new_captcha_code': 'Gerar novo código',
        // Update App
        'update': 'Atualizar',
        'updated': 'Atualizado',
        'update_app': 'Atualização do App',
        'new_version_app': 'Nova versão do aplicativo 🎉',
        'new_version_app_message':
            'Uma nova versão do aplicativo está pronta para download, trazendo correções de bugs e melhorias gerais.',
        'update_now_button': 'Atualize agora',
        'update_later_button': 'Mais tarde',
        // Updated App
        'updated_app_title': 'O que há de novo',
        'updated_app_message': 'O que há de novo no App {version} 👋🏼',
        'updated_finish_button': 'Ir para a Home',
        'blocking_app_title': '🐞 Estamos em manutenção',
        'blocking_app_message':
            'O aplicativo está indisponível no momento, em breve você poderá utilizar o App novamente.',
        'blocking_push_notification':
            'Você será notificado quando o aplicativo estiver disponível novamente.',
        // Search Delegate
        'search': 'Pesquisar',
        // Web Visit History
        'web_visit_history': 'Histórico de visitas',
        'empty_web_visit_history_list': 'Histórico de visitas vazio',
        'delete': 'Deletar',
        'change': 'Alterar',
        'yes': 'Sim',
        'not': 'Não',
        // Error Page
        'error_page_title': 'Oops, algo deu errado!',
        'error_page_message':
            'Tivemos um problema interno. Tente novamente em alguns instantes.',
        'error_webview_no_network_title': 'Você está sem conexão',
        'error_webview_no_network_message':
            'Verifique sua conexão com a internet e tente novamente',
        'slow_network_title': 'Sua conexão está um pouco lenta',
        // Theme Page
        'launcher_icon': 'Ícone do App',
        'change_launcher_icon': 'Ícone trocado',
        'need_restart_the_app': 'É necessário reiniciar o aplicativo',
      },
    };
  }
}
