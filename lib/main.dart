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

  try {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
    );
  } catch (_) {}

  final client = Client()
    ..setEndpoint(AppWriteConstant.endPoint)
    ..setProject(AppWriteConstant.projectId)
    ..setSelfSigned(status: true);

  try {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await Workmanager().registerPeriodicTask(
      'dailyNotificationTask',
      'dailyNotificationTask',
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(hours: 24),
      inputData: <String, dynamic>{'balance': '3000'},
    );
  } catch (_) {}

  runApp(MyApp(client: client));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    NotificationServices.sendDailyNotification('3000');
    return Future.value(true);
  });
}
