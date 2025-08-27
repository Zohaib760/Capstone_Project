// import 'package:flutter/material.dart';
// import '../Services/notification_service.dart';
//
//
// class NotificationsScreen extends StatefulWidget {
//   @override
//   _NotificationsScreenState createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   final NotificationService _notificationService = NotificationService();
//   final List<Map<String, dynamic>> _notifications = [
//     {
//       'id': 1,
//       'title': 'Welcome to the App!',
//       'body': 'Thank you for installing our application.',
//       'time': '2 hours ago',
//       'read': false,
//     },
//     {
//       'id': 2,
//       'title': 'New Features Available',
//       'body': 'Check out the latest features we\'ve added to the app.',
//       'time': '1 day ago',
//       'read': true,
//     },
//     {
//       'id': 3,
//       'title': 'Weekly Summary',
//       'body': 'Here\'s your weekly activity summary.',
//       'time': '3 days ago',
//       'read': true,
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _notificationService.initialize();
//   }
//
//   Future<void> _scheduleNotification() async {
//     final scheduledTime = DateTime.now().add(Duration(seconds: 10));
//     await _notificationService.scheduleNotification(
//       id: 100,
//       title: 'Scheduled Notification',
//       body: 'This notification was scheduled from the app',
//       scheduledTime: scheduledTime,
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Notification scheduled for ${scheduledTime.hour}:${scheduledTime.minute}')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add_alarm),
//             onPressed: _scheduleNotification,
//             tooltip: 'Schedule Notification',
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: _notifications.length,
//         itemBuilder: (context, index) {
//           final notification = _notifications[index];
//           return Card(
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             color: notification['read'] ? null : Colors.blue[50],
//             child: ListTile(
//               leading: Icon(
//                 Icons.notifications,
//                 color: notification['read'] ? Colors.grey : Colors.blue,
//               ),
//               title: Text(
//                 notification['title'],
//                 style: TextStyle(
//                   fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(notification['body']),
//                   SizedBox(height: 4),
//                   Text(
//                     notification['time'],
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               trailing: notification['read']
//                   ? null
//                   : Icon(Icons.circle, color: Colors.blue, size: 12),
//               onTap: () {
//                 setState(() {
//                   notification['read'] = true;
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _notificationService.showNotification(
//             id: DateTime.now().millisecondsSinceEpoch % 1000,
//             title: 'Test Notification',
//             body: 'This is a test notification triggered from the app',
//           );
//         },
//         child: Icon(Icons.notification_add),
//         tooltip: 'Send Test Notification',
//       ),
//     );
//   }
// }