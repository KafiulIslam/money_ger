import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/constant/constant.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, MonthlyBudgetProvider>(
        builder: (_, authState, monthlyBudgetState, child) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: primeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            '${AppConstant.currentMonth} Report',
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(
                        value: monthlyBudgetState.family.toDouble(),
                        //title: 'Family',
                        showTitle: false,
                        radius: 60,
                        color: secondaryColor),
                    PieChartSectionData(
                        value: monthlyBudgetState.personal.toDouble(),
                        //title: 'Personal',
                        showTitle: false,
                        radius: 60,
                        color: primeColor),
                    PieChartSectionData(
                        value: monthlyBudgetState.transport.toDouble(),
                        // title: 'Transport',
                        showTitle: false,
                        radius: 60,
                        color: Colors.green),
                    PieChartSectionData(
                        value: monthlyBudgetState.donation.toDouble(),
                        //title: 'Donation',
                        showTitle: false,
                        radius: 60,
                        color: red),
                    PieChartSectionData(
                        value: monthlyBudgetState.medicine.toDouble(),
                        //title: 'Medicine',
                        showTitle: false,
                        radius: 60,
                        color: Colors.tealAccent),
                    PieChartSectionData(
                        value: monthlyBudgetState.other.toDouble(),
                        //title: 'Other',
                        showTitle: false,
                        radius: 60,
                        color: Colors.yellowAccent),
                  ])),
                ),
                sixteenVerticalSpace,
               _buildColorIndicator(),
                const Divider(),
                sixteenVerticalSpace,
                _infoTile('Family', monthlyBudgetState.family.toString()),
                sixteenVerticalSpace,
                _infoTile('Personal', monthlyBudgetState.personal.toString()),
                sixteenVerticalSpace,
                _infoTile('Transport', monthlyBudgetState.transport.toString()),
                sixteenVerticalSpace,
                _infoTile('Donation', monthlyBudgetState.donation.toString()),
                sixteenVerticalSpace,
                _infoTile('Medicine', monthlyBudgetState.medicine.toString()),
                sixteenVerticalSpace,
                _infoTile('Other', monthlyBudgetState.other.toString()),
                const Divider(),
                _infoTile('Total Expense',
                    monthlyBudgetState.totalMonthlyExpense.toString()),
                primaryVerticalSpace,
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _infoTile(String title, String info) {
    return Row(
      children: [
        Text(
          title,
          style: tTextStyle600.copyWith(color: black, fontSize: 16),
        ),
        const Spacer(),
        Text(
          info,
          style: tTextStyle600.copyWith(color: iconColor, fontSize: 16),
        )
      ],
    );
  }

  Widget _graphColorIndicator(Color color, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: color,
        ),
        eightHorizontalSpace,
        Text(
          title,
          style: tTextStyle500.copyWith(color: iconColor, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildColorIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _graphColorIndicator(secondaryColor, 'Family'),
          _graphColorIndicator(primeColor, 'Personal'),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _graphColorIndicator(Colors.green, 'Transport'),
          _graphColorIndicator(red, 'Donation'),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _graphColorIndicator(Colors.tealAccent, 'Medicine'),
          _graphColorIndicator(Colors.yellowAccent, 'Other'),
        ],
      ),
    ],);
  }
}
