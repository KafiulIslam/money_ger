import 'package:flutter/material.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/history/monthlyDetail/monthly_detail.dart';
import 'package:money_ger/views/dashboard/history/widgets/monthly_history_expansion.dart';
import 'package:money_ger/widgets/components/monthly_budget_card.dart';
import 'package:provider/provider.dart';
import '../../../models/expense_model.dart';
import '../../../utils/color.dart';
import '../../../utils/constant/constant.dart';
import '../../../utils/custom_dialog.dart';
import '../home/widgets/add_budget_bottomsheet.dart';
import '../home/widgets/custom_expansion_tile.dart';

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

                    // return ExpansionTile(
                    //   collapsedBackgroundColor: white,
                    //   backgroundColor: trans,
                    //   collapsedTextColor: textColorBold,
                    //   textColor: black,
                    //   collapsedShape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       side: BorderSide(color: borderColor)),
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       side: BorderSide(color: borderColor)),
                    //   collapsedIconColor: black,
                    //   iconColor: iconColor,
                    //   childrenPadding: const EdgeInsets.all(16.0),
                    //   title: Text(
                    //     monthlyBudgetId,
                    //     style:
                    //         tTextStyle700.copyWith(color: black, fontSize: 16),
                    //   ),
                    //   subtitle: Text(
                    //     "${monthlyTotal.toString()} Tk",
                    //     style:
                    //     tTextStyle600.copyWith(color: black, fontSize: 14),
                    //   ),
                    //   children: expenses.map((expense) {
                    //     return ListTile(
                    //       title: Text(expense.description, style:
                    //       tTextStyle600.copyWith(color: black, fontSize: 14)),
                    //       subtitle: Text(expense.expenseType,style:
                    //       tTextStyleRegular.copyWith(color: black, fontSize: 14)),
                    //       trailing:
                    //           Text('${expense.expenseAmount.toString()} Tk', style:
                    //           tTextStyle700.copyWith(color: iconColor, fontSize: 14)),
                    //     );
                    //   }).toList(),
                    // );
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MonthlyDetail(
                    monthId: monthId, expensesList: expensesList)));
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
                  Text(
                    "${monthlyTotal.toString()} Tk",
                    style: tTextStyle600.copyWith(color: black, fontSize: 14),
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
