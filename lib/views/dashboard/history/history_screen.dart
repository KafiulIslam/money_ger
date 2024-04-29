import 'package:flutter/material.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/history/widgets/monthly_history_expansion.dart';
import 'package:money_ger/widgets/components/monthly_budget_card.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
import '../../../utils/constant/constant.dart';
import '../../../utils/custom_dialog.dart';
import '../home/widgets/add_budget_bottomsheet.dart';
import '../home/widgets/custom_expansion_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, MonthlyBudgetProvider>(
        builder: (_, authState, monthlyBudgetState, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'History',
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () {
              return monthlyBudgetState.getExpenseList();
            },
            child: ListView.separated(
                itemBuilder: (_, index) {
                  //var data = monthlyBudgetState.monthlyBudgetList[index];
                  return MonthlyBudgetCard(
                      monthId: 'data.monthId',
                      budget: 100);
                },
                separatorBuilder: (_, index) => sixteenVerticalSpace,
                itemCount: 3),
          ),
        ),
      );
    });
  }

  Widget _monthlyBudgetCard(BuildContext context) {
    final monthlyBudgetState =
        Provider.of<MonthlyBudgetProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: primaryColor),
      child: monthlyBudgetState.isBudgetLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppConstant.currentMonth,
                        style:
                            tTextStyleBold.copyWith(fontSize: 18, color: white),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 36,
                        width: 42,
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: white,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Budget',
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          const Spacer(),
                          Text(
                            monthlyBudgetState.monthlyBudget.toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                      eightVerticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "Balance in ${AppConstant.currentMonth}",
                            "Expense",
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          Text(
                            monthlyBudgetState.totalMonthlyExpense.toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                      eightVerticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "Balance in ${AppConstant.currentMonth}",
                            "Balance",
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          Text(
                            (monthlyBudgetState.monthlyBudget -
                                    monthlyBudgetState.totalMonthlyExpense)
                                .toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
