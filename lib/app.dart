import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/controllers/fixed_cost_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/controllers/monthly_detail_controller.dart';
import 'package:money_ger/routes/app_routes.dart';
import 'package:money_ger/utils/color.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_provider.dart';

class MyApp extends StatefulWidget {
  final Client client;

  const MyApp({Key? key, required this.client})
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
        ChangeNotifierProvider(create: (context) => MonthlyDetailController()),
        ChangeNotifierProvider(create: (context) => FixedCostProvider()),
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
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        title: "MoneyGer",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            drawerTheme: const DrawerThemeData(backgroundColor: white),
          ),
      ),
    );
  }
}
