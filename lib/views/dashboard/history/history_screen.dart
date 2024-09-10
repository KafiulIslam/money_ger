import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:money_ger/views/dashboard/history/monthlyDetail/monthly_detail.dart';
import 'package:provider/provider.dart';
import '../../../models/expense_model.dart';
import '../../../routes/route_path.dart';
import '../../../utils/color.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthlyBudgetProvider>(
        builder: (_, monthlyBudgetState, child) {
      return Scaffold(
        backgroundColor: scaffoldColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: primeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'History',
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: monthlyBudgetState.expensesByMonth.isEmpty
              ? const Center(child: Text('No available history'))
              : ListView.separated(
                  itemCount: monthlyBudgetState.expensesByMonth.length,
                  separatorBuilder: (_, index) => sixteenVerticalSpace,
                  itemBuilder: (context, index) {
                    String monthlyBudgetId = monthlyBudgetState
                        .expensesByMonth.keys
                        .elementAt(index);
                    int monthlyTotal = monthlyBudgetState
                        .totalExpensesByMonth.values
                        .elementAt(index);

                    List<ExpenseModel> expenses =
                        monthlyBudgetState.expensesByMonth[monthlyBudgetId]!;

                    return _historyTile(
                        monthlyBudgetId, monthlyTotal, expenses);
                  },
                ),
        ),
      );
    });
  }

  Widget _historyTile(
      String monthId, int monthlyTotal, List<ExpenseModel> expensesList) {
    return InkWell(
      onTap: () {
        MonthlyDetail data =
            MonthlyDetail(monthId: monthId, expensesList: expensesList);
        context.goNamed(RouterPath.monthlyDetail, extra: data);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: borderColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthId,
                    style: tTextStyle700.copyWith(color: black, fontSize: 16),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  // Text(
                  //   "${monthlyTotal.toString()}",
                  //   style: tTextStyle600.copyWith(color: black, fontSize: 14),
                  // ),
                  RichText(
                    text: TextSpan(
                      text: '$userCurrency ',
                      style: tTextStyle600.copyWith(
                          color: iconColor, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: monthlyTotal.toString(),
                            style: tTextStyle600.copyWith(
                                color: black, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
