class AppConstants {
  static const String appName = 'Capstone App';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

  // Storage keys
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';
  static const String usernameKey = 'username';
  static const String notificationsEnabledKey = 'notificationsEnabled';
  static const String darkModeKey = 'darkMode';
  static const String languageKey = 'language';

  // Notification channels
  static const String notificationChannelId = 'capstone_channel';
  static const String notificationChannelName = 'Capstone Notifications';
}

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
}