// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   NotificationService._internal();
//
//   factory NotificationService() => _instance;
//
//   Future<void> initialize() async {
//     // Initialize timezone for scheduling
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings androidInitializationSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: androidInitializationSettings);
//
//     await _notificationsPlugin.initialize(initializationSettings);
//   }
//
//   // 🔔 Show an instant notification
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'capstone_channel',
//       'Capstone Notifications',
//       channelDescription: 'This channel is used for important notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await _notificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   // ⏰ Schedule a one-time notification
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'capstone_channel',
//       'Capstone Notifications',
//       channelDescription: 'This channel is used for scheduled notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local), // ✅ Convert DateTime → TZDateTime
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // 🔁 Example: Repeat daily notification
//   Future<void> showDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime time, // Flutter's Time class
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'capstone_channel',
//       'Capstone Notifications',
//       channelDescription: 'This channel is used for daily reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       _nextInstanceOfTime(time),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time, // ✅ Repeats daily
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // Helper: Calculate next instance of a given time
//   tz.TZDateTime _nextInstanceOfTime(DateTime time) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//       time.second,
//     );
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }
