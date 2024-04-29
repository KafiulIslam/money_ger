import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_provider.dart';

class MyApp extends StatefulWidget {
  final Client client;
  final String sessionId;

  const MyApp({Key? key, required this.client, required this.sessionId})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Databases db;

  @override
  void initState() {
    db = Databases(widget.client);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MonthlyBudgetProvider()),
        ChangeNotifierProvider(create: (context) => DebitCreditProvider()),
        // ChangeNotifierProvider(create: (context) => goalsListProvider),
        // ChangeNotifierProvider(
        //     create: (context) => HomeProvider(
        //         tasksListProvider: tasksListProvider,
        //         goalsListProvider: goalsListProvider)),
        // ChangeNotifierProvider(
        //     create: (context) => EditTaskProvider(
        //         db: db,
        //         tasksListProvider: tasksListProvider,
        //         goalsListProvider: goalsListProvider)),
        // ChangeNotifierProvider(
        //     create: (context) => EditGoalsProvider(
        //         db: db, goalsListProvider: goalsListProvider)),
        // ChangeNotifierProvider(
        //     create: (context) => TaskDetailsProvider(db: db)),
        // ChangeNotifierProvider(
        //     create: (context) => TodayTasksListProvider(db: db)),
        // ChangeNotifierProvider(
        //     create: (context) => ExistingTasksProvider(db: db)),
        // ChangeNotifierProvider(
        //     create: (context) => GoalDetailsProvider(db: db)),

        // ChangeNotifierProvider(create: (context) => ProfileProvider()),
        // ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        title: "MoneyGer",
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          sessionId: widget.sessionId,
        ),
      ),
    );
  }
}
