import 'package:core/core.dart';

class AppPtBrTranslation extends PtBrTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app':
            'Um gerenciador de senhas seguro e intuitivo para armazenar, organizar e proteger suas credenciais em um só lugar. Salve suas senhas, acesse seus dados com rapidez e mantenha suas contas protegidas com criptografia avançada.',
        'credentials': 'Minhas senhas',
        'empty_credentials_list': 'Você ainda não tem credenciais',
        'credential': 'Senha',
        'credential_name': 'Nome da credencial',
        'credential_name_input_error': 'Digite o nome da credencial',
        'username': 'Nome do usuário',
        'credential_username': 'Nome do usuário da credencial',
        'username_copied': 'Nome do usuário copiado!',
        'password_copied': 'Senha copiada!',
        'credential_secret_otp': 'Chave de Autenticação (TOTP)',
        'notes': 'Notas',
        'credential_notes': 'Digite aqui notas ou observações',
        'url_link_copied': 'Link copiado!',
        'search_credentials_not_found':
            'Nenhuma credencial com este nome foi encontrada',
        'your_password_was_used': 'Sua senha já foi utilizada',
        'your_password_was_used_one_time': 'vez',
        'your_password_was_used_many_times': 'vezes',
      },
    };
  }
}
