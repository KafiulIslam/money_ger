//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// class MoneyGerNotification {
//
//   // Future<void> scheduleDailyNotification() async {
//   //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//   //       'daily_reminder_channel_id', 'Daily Reminder',
//   //       channelDescription: 'Daily reminder notification',
//   //       importance: Importance.max,
//   //       priority: Priority.high);
//   //
//   //   const NotificationDetails platformDetails = NotificationDetails(
//   //       android: androidDetails);
//   //
//   //   await flutterLocalNotificationsPlugin.showDailyAtTime(
//   //     0, // notification ID
//   //     'Daily Reminder',
//   //     'This is your daily notification!',
//   //     Time(10, 0, 0), // Time to show the notification (e.g., 10:00 AM)
//   //     platformDetails,
//   //   );
//   //   //
//   //   // await flutterLocalNotificationsPlugin.periodicallyShow(
//   //   //     0, 'Daily Reminder', 'This is your daily notification!', ,
//   //   //     24, platformDetails);
//   // }
//
//   static Future<void> scheduleDailyNotification() async {
//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 0, 0);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0, // notification ID
//       'Daily Reminder',
//       'This is your daily notification!',
//       scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime, // Check if the time is in the past, if so, schedule for the next day
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_reminder_channel_id',
//           'Daily Reminder',
//           channelDescription: 'Daily reminder notification',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true, // Allow notification to show even if the device is idle
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
//       matchDateTimeComponents: DateTimeComponents.time, // Repeat the notification daily at the same time
//     );
//   }
//
//
//
// }