import 'package:flutter/material.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/constant/constant.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/home/widgets/add_budget_bottomsheet.dart';
import 'package:money_ger/views/home/widgets/add_expense_bottomsheet.dart';
import 'package:money_ger/views/home/widgets/custom_expansion_tile.dart';
import 'package:provider/provider.dart';
import '../../utils/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, MonthlyBudgetProvider>(
        builder: (_, authState, monthlyBudgetState, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            '${AppConstant.currentMonth} History',
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  authState.logout(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _monthlyBudgetCard(context),
              sixteenVerticalSpace,
              Expanded(
                child: ListView.separated(
                    itemBuilder: (_, index) {
                      var data = monthlyBudgetState.expenseList[index];
                      return CartExpansionTile(
                          monthlyBudgetId: data.monthlyBudgetId,
                          description: data.description,
                          expenseType: data.expenseType,
                          expenseAmount: data.expenseAmount,
                          uid: data.uid,
                          createdAt: data.createdAt);
                    },
                    separatorBuilder: (_, index) => sixteenVerticalSpace,
                    itemCount: monthlyBudgetState.expenseList.length),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: () {
            CustomDialog.bottomSheet(context, const AddExpenseBottomSheet());
          },
          child: const Icon(
            Icons.add,
            color: white,
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
                    // InkWell(
                    //   onTap: () {
                    //     CustomDialog.bottomSheet(
                    //         context, const AddBudgetBottomSheet());
                    //   },
                    //   child: CircleAvatar(
                    //     radius: 15,
                    //     backgroundColor: white,
                    //     child: Icon(
                    //       monthlyBudgetState.monthlyBudget == 00
                    //           ? Icons.add
                    //           : Icons.edit,
                    //       size: 20,
                    //       color: secondaryColor,
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        CustomDialog.bottomSheet(
                            context, const AddBudgetBottomSheet());
                      },
                      child: Container(
                        height: 36,
                        width: 42,
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Icon(
                          monthlyBudgetState.monthlyBudget == 00
                              ? Icons.add
                              : Icons.edit,
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
