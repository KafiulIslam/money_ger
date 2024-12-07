import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/app.dart';
import 'package:money_ger/utils/constant/appwrite_constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'controllers/notification_services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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


  /// Initialize WorkManager

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Schedule the periodic task
  Workmanager().registerPeriodicTask(
    "dailyNotificationTask",
    "dailyNotificationTask",
    frequency: Duration(hours: 24),
    initialDelay: Duration(hours: 24),
    inputData: <String, dynamic>{'balance': '3000'}, // Pass data if needed
  );

  runApp(MyApp(client: client));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    NotificationServices.sendDailyNotification('3000');
    return Future.value(true);
  });
}
