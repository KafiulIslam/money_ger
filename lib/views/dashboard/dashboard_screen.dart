import 'package:flutter/material.dart';
import 'package:money_ger/views/dashboard/debitCredit/debit_credit_screen.dart';
import 'package:money_ger/views/dashboard/fixedCost/fixed_cost_screen.dart';
import 'package:money_ger/views/dashboard/history/history_screen.dart';
import 'package:money_ger/views/dashboard/home/report/report_screen.dart';
import '../../utils/app_storage.dart';
import '../../utils/color.dart';
import 'home/home_screen.dart';

late String userCurrency = '';

Future<void> getUserCurrency () async {
  userCurrency = await AppStorage.getCurrency() ?? '';
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ReportScreen(),
    HistoryScreen(),
    DebitCreditScreen(),
    FixedCostScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getUserCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_score_sharp),
            label: 'Debts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed),
            label: 'Fixed Cost',
          ),
        ],
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: scaffoldColor,
        currentIndex: _selectedIndex,
        selectedItemColor: primeColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
