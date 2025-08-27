import 'package:flutter/material.dart';

import 'Screens/favorite_screen.dart';
import 'Screens/log_in_screen.dart';
import 'Screens/setting_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/notifications_screen.dart';

import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services before runApp
  final storageService = StorageService();
  await storageService.initialize();

  // final notificationService = NotificationService();
  // await notificationService.initialize();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    final userId = storageService.getInt(AppConstants.userIdKey);

    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.signup: (context) => SignUpScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.detail: (context) =>
            DetailScreen(itemId: 0), // placeholder, will be replaced dynamically
        AppRoutes.favorites: (context) => FavoritesScreen(),
        AppRoutes.settings: (context) => SettingsScreen(),
        // AppRoutes.notifications: (context) => NotificationsScreen(),
      },
      // ✅ No FutureBuilder needed
      home: userId != null ? HomeScreen() : LoginScreen(),
    );
  }
}
