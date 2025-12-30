import 'package:dependency/dependency.dart';

class EnUsTranslation extends Translations {
  final String localeName = 'en_US';

  @override
  Map<String, Map<String, String>> get keys {
    return {
      localeName: {
        // Intro
        'back_intro': 'Back',
        'next_intro': 'Next',
        'finish_intro': 'Finish',
        'title_intro_app_tracking': 'Allow tracking',
        'body_intro_app_tracking':
            'Allow the App to track your online activity for a personalized experience.',
        'title_intro_notification': 'Notifications',
        'body_intro_notification':
            'Turn on notifications and stay up to date with the news that really matters',
        'title_intro_location': 'Location',
        'body_intro_location':
            'Allow the App to track your location for a personalized experience.',
        // Defaults
        'default_error': 'An error, try again',
        'internet_error_connection': 'Check your network connection',
        'continue': 'Continue',
        'try_again': 'Try Again',
        // Web App
        'welcome_app': 'Welcome to {appName}',
        'features_web_nav_bar': 'Features',
        'download_web_nav_bar': 'Download',
        'about_web_nav_bar': 'About',
        'contact_web_nav_bar': 'Contact',
        'about_web_app': 'About us',
        'contact_web': 'Contact',
        'follow_our_social_media': 'Follow us on social media too',
        'sac_help': 'Help and support',
        'copyright_web_app': 'All rights reserved.',
        'features_web_app': 'Features',
        'download_app': 'Download App',
        // Login
        'login': 'Login',
        //
        'username_label': 'E-mail',
        'username_input_hint': 'Type your e-mail here',
        'username_input_empty_error': 'Type your e-mail',
        'name_input_empty_error': 'Enter your name',
        'email_input_empty_error': 'Enter your email',
        'email_input_invalid_error': 'Enter a valid email address',
        //
        'password_label': 'Password',
        'password_input_hint': 'Type your password here',
        'password_input_empty_error': 'Type your password',
        'password_not_equals_error': 'Passwords are not the same',
        'url_input_invalid_error': 'Invalid Url Link',
        'secret_otp_invalid': 'Invalid authentication key',
        //
        'recovery_password_button': 'Type your password',
        'login_button': 'Signin',
        //
        'create_new_account': 'Create new account',
        //
        'invalid_username_password': 'Invalid username or password',
        'remember_my_email': 'Remember my e-mail',
        // Recovery Password
        'recovery_password': 'Recover your password',
        'recovery_password_message':
            'Enter your email to recover your password',
        'recovery_password_success_title': 'Email sent successfully!',
        'recovery_password_success_message':
            'Check your email to recover your password.',
        // Admin
        'users': 'Users',
        'admin_user_details': 'User details',
        'delete_user_account': 'Delete account',
        'user_sessions': 'User sessions',
        // Home
        'home': 'Home',

        'settings': 'Settings',
        // Settings
        'version': 'Version',
        'my_data': 'My data',
        'language': 'Language',
        'theme': 'Theme',
        'change_password': 'Change password',
        'about': 'About',
        'logout': 'Logout',
        'want_to_clear_cache': 'Do you want to clear the data?',
        'clear_cache': 'Clear',
        'back': 'Return',
        'language_selection': 'Language Selection',
        'choose_theme_app': 'Choose a theme for the app',
        'history': 'My history',
        'notifications': 'Notifications',
        'clear_local_cache': 'Clear app cache',
        'open_website': 'Visit website',
        'delete_my_account': 'Delete my account',
        'delete_account_title': 'Why are you closing your account?',
        'delete_account_reason_1': '''It doesn't meet my needs.''',
        'delete_account_reason_2': 'I prefer not to answer.',
        'delete_account_reason_3':
            '''I didn't understand how the product works.''',
        'delete_account_reason_4': 'Another reason.',
        'finish_my_account': 'Close account',
        'delete_account_finish_title':
            'Are you sure you want to delete your account?',
        'delete_account_finish_feature_1':
            'When you close your account, you will lose access to many features of the app, including the ability to save and manage your credentials.',
        'delete_account_finish_feature_2':
            'All your data will be permanently removed and cannot be recovered.',
        'delete_account_finish_feature_3':
            'This action is irreversible.\nDo you really want to continue?',
        'not_delete_my_account': '''I don't want to close my account''',
        'warning': 'Attention!',
        'delete_account_information_title':
            'By confirming your account closure, all your data will be permanently deleted and cannot be recovered. This includes:',
        'delete_account_information_1': '> Personal information;',
        'delete_account_information_2': '> Usage history;',
        'delete_account_information_3':
            '> All credentials created in the application;',
        'delete_account_information_info':
            'This action is irreversible. Make sure you really want to proceed before confirming.',
        'delete_account_success': 'Account closure\nsuccessfully requested',
        'delete_account_success_message':
            'Thank you for trying our App, We hope to see you back.',
        // Language
        'pt': 'Portuguese',
        'en': 'English',
        // Terms and Policy Privacy
        'terms_conditions': 'Terms condition',
        'privacy_policy': 'Privacy Policy',
        // Permissions
        'allow': 'Allow',
        'allow_later': 'Not now',
        'permission.contacts_title': 'Contacts Permission',
        'permission.contacts_message':
            'We will need your contacts list to give better experience.',
        'permission.location_title': 'Location Permission',
        'permission.location_message':
            'We will need your location to give better experience.',
        //
        'remove': 'Remove',
        'cancel': 'Cancel',
        'ok': 'Ok',
        'save': 'Save',
        //
        // Notifications Settings
        'notification': 'Notifications',
        'push_enabled': 'enabled',
        'push_disabled': 'disabled',
        'notifications_settings': 'Notifications Settings',
        'allow_push_notifications': 'Allow notifications',
        'no_push_permissions': 'No permissions',
        'you_need_enabled_push_permissions':
            "You need to enable the app's notification permissions!",
        'you_will_receive_notifications': 'You will receive notifications!',
        'push_notifications_disabled':
            'Your notification has been turned off\nYou will no longer receive messages!',
        'push_notifications': 'Notificação Push',
        'send_push_notification_test':
            'A test notification will be sent to your app.',
        'send_push_test': 'Send test',
        'test_push_send_success_title': 'Test Push Sent',
        'test_push_send_success_message':
            'Test Push Notification was sent to this device',
        // Security
        'security': 'Security',
        'biometric': 'Biometric',
        'biometric_enabled': 'Biometrics activated',
        'biometric_disabled': 'Biometrics disabled',
        'biometric_message':
            'With biometrics activated, the App will be more secure and only you will be able to access the application.',
        'biometric_not_supported':
            'Unfortunately your device does not support biometrics',
        'biometrics_authenticate_message':
            'Use your biometrics to unlock the app.',
        'blocked_app': 'Application Blocked',
        'use_biometrics_to_unlock_app': 'Use biometrics to unlock the App',
        'unlock_app': 'Unlock',
        'biometrics_success_activated':
            'Your biometrics have been successfully activated!',
        'biometrics_disabled': 'Your biometrics have been disabled',
        'device_not_support_biometrics':
            'Your device does not support biometrics.',
        'blur_protect_enabled': 'Read protection enabled',
        'blur_protect_disabled': 'Read protection disabled',
        'blur_protect_message':
            'With read protection enabled, the content will be unreadable when the app is not open.',
        //
        'logout_app_message':
            'Are you sure you want to log out of your account?',
        // Contact

        // Change Password
        'current_password': 'Current password',
        'new_password': 'New password',
        'create_strong_password': 'Create a strong password',
        'repeat_password': 'Repeat password',
        'repeat_password_hint': 'Repeat new password',
        'change_password_success_title': 'Password changed',
        'change_password_success_message':
            'Your password has been changed successfully!',
        'new_password_not_be_equal_old_password':
            'The new password cannot be the same as the current one',
        'confirm_password_not_equal': 'Passwords are not the same',
        // Signup
        'name': 'Name',
        'enter_your_full_name': 'Enter your full name',
        'signup': 'Create account',
        'fill_the_captcha': 'Fill in the Captcha',
        'generate_new_captcha_code': 'Generate new code',
        // Update App
        'update': 'Update',
        'updated': 'Updated at',
        'update_app': 'App Update',
        'new_version_app': 'New version of the app 🎉',
        'update_news_title': '✨ New features',
        'update_improvements_title': '💎 Improvements',
        'update_fixes_title': '🐞 Bug fixes',
        'update_now_button': 'Update now',
        'update_later_button': 'Later',
        // Updated App
        'updated_app_title': '''What's new''',
        'updated_app_message': '''What's new in the App {version} 👋🏼''',
        'updated_finish_button': 'Go to Home',
        // Search Delegate
        'search': 'Search',
        // Web Visit History
        'web_visit_history': 'Web visit history',
        'empty_web_visit_history_list': 'Empty web visit history',
        // Work Points
        'remember_my_credentials': 'Remember my credentials',
        'change_month': 'Change month',
        'holiday': 'Holiday',
        'weekend': 'Weekend',
        'total_hours': 'Total hours',
        'total_budget': 'Budget',
        'make_check_point': 'Make check point',
        'make_check_point_now': 'Do you want to check point now?',
      },
    };
  }
}
