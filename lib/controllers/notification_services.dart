import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';

class NotificationServices {
  static void sendNotification() async {
    if (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('channelId', 'channelName',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true);

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
          0, 'MoneyGer', 'Notification from moneyger', notificationDetails);
    }
  }

  static Future<bool> sendDailyNotification(String balance) async {
    if (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('channelId', 'channelName',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true);

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.periodicallyShow(
          0,
          'MoneyGer',
          //'Record today\'s expenses in MoneyGer. Current balance: $balance',
          'Record today\'s transactions in MoneyGer.',
          RepeatInterval.daily,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exact);
      return true;
    } else {
      return false;
    }
  }
}
