import 'package:core/core.dart';

class AppEnUsTranslation extends EnUsTranslation {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        ...super.keys[localeName]!,
        'body_intro_app':
            'A secure and intuitive password manager to store, organize, and protect your credentials in one place. Save your passwords, access your data quickly, and keep your accounts protected with advanced encryption.',
        'credentials': 'My passwords',
        'empty_credentials_list': '''You don't have credentials yet''',
        'credential': 'Password',
        'credential_name': 'Credential name',
        'credential_name_input_error': 'Enter the credential name',
        'username': 'Username',
        'credential_username': 'Credential username',
        'username_copied': 'Username copied!',
        'password_copied': 'Password copied!',
        'credential_secret_otp': 'Authentication Key (TOTP)',
        'notes': 'Notes',
        'credential_notes': 'Enter notes or observations here',
        'url_link_copied': 'Link copied!',
        'search_credentials_not_found':
            'No credentials with this name were found',
        'your_password_was_used': 'Your password has already been used',
        'your_password_was_used_one_time': 'time',
        'your_password_was_used_many_times': 'times',
      },
    };
  }
}
