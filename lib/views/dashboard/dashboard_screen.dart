import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_ger/utils/assets_path.dart';
import 'package:money_ger/views/dashboard/debitCredit/debit_credit_screen.dart';
import 'package:money_ger/views/dashboard/fixedCost/fixed_cost_screen.dart';
import 'package:money_ger/views/dashboard/history/history_screen.dart';
import 'package:money_ger/views/dashboard/home/report/report_screen.dart';
import '../../utils/app_storage.dart';
import '../../utils/color.dart';
import 'home/home_screen.dart';

late String userCurrency = '';

Future<void> getUserCurrency() async {
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              homeIcon,
              color: _selectedIndex == 0 ? primeColor : iconColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              reportIcon,
              color: _selectedIndex == 1 ? primeColor : iconColor,
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              historyIcon,
              color: _selectedIndex == 2 ? primeColor : iconColor,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              debtIcon,
              color: _selectedIndex == 3 ? primeColor : iconColor,
            ),
            label: 'Debts',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              fixedCostIcon,
              color: _selectedIndex == 4 ? primeColor : iconColor,
            ),
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
