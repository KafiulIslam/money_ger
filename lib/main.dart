import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/app.dart';
import 'package:money_ger/utils/app_storage.dart';
import 'package:money_ger/utils/constant/appwrite_constant.dart';
import 'package:money_ger/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  client
      .setEndpoint(AppWriteConstant.endPoint)
      .setProject(AppWriteConstant.projectId)
      .setSelfSigned(status: true);

  final String sessionId = await AppStorage.getSessionId() ?? '';

  runApp(MyApp(client: client, sessionId: sessionId));
}
