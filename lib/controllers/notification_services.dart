// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationServices {
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   final AndroidInitializationSettings _androidInitializationSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   void initialiseNotifications() async {
//     InitializationSettings initializationSettings =
//         InitializationSettings(android: _androidInitializationSettings);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   void sendNotification() async {
//
//
//     if (await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission() ??
//         false) {
//       // Permission granted
//     }
//
//     print('kafi one');
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true);
//     print('kafi two');
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//
//     print('kafi tree');
//    await _flutterLocalNotificationsPlugin.show(
//         0, 'MoneyGer', 'Notification from moneyger', notificationDetails);
//     print('kafi four');
//   }
// }
