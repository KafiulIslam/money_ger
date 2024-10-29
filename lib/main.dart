import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/app.dart';
import 'package:money_ger/utils/constant/appwrite_constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void sendNotification() async {


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

void sendDailyNotification() async {


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
        0, 'schedule', 'schedule lkadjfl Notification from moneyger', RepeatInterval.everyMinute,notificationDetails);


  }


}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// for notification ///

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  /// for appwrite ///

  Client client = Client();
  client
      .setEndpoint(AppWriteConstant.endPoint)
      .setProject(AppWriteConstant.projectId)
      .setSelfSigned(status: true);

  runApp(MyApp(client: client));
}


// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // Schedule daily notification here
//     //await scheduleDailyNotification();
//     await MoneyGerNotification.scheduleDailyNotification();
//     return Future.value(true);
//   });
// }