import 'package:flutter/material.dart';
import '../../utils/color.dart';
import '../../utils/spacer.dart';
import '../../utils/typograpgy.dart';

class MonthlyBudgetCard extends StatelessWidget {
  final String monthId;
  final int budget;

  const MonthlyBudgetCard(
      {Key? key,
      required this.monthId,
      required this.budget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: primaryColor),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  monthId,
                  style: tTextStyleBold.copyWith(fontSize: 18, color: white),
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
                      style:
                          tTextStyleBold.copyWith(fontSize: 18, color: white),
                    ),
                    const Spacer(),
                    Text(
                      //monthlyBudgetState.monthlyBudget.toString(),
                     budget.toString(),
                      style: tTextStyle700.copyWith(fontSize: 16, color: white),
                    ),
                  ],
                ),
                eightVerticalSpace,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       // "Balance in ${AppConstant.currentMonth}",
                //       'Expense',
                //       style:
                //           tTextStyleBold.copyWith(fontSize: 18, color: white),
                //     ),
                //     Text(
                //       // monthlyBudgetState.totalMonthlyExpense.toString(),
                //       expense,
                //       style: tTextStyle700.copyWith(fontSize: 16, color: white),
                //     ),
                //   ],
                // ),
                // eightVerticalSpace,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       // "Balance in ${AppConstant.currentMonth}",
                //       "Balance",
                //       style:
                //           tTextStyleBold.copyWith(fontSize: 18, color: white),
                //     ),
                //     Text(
                //       // (monthlyBudgetState.monthlyBudget -
                //       //     monthlyBudgetState.totalMonthlyExpense)
                //       //     .toString(),
                //       balance,
                //       style: tTextStyle700.copyWith(fontSize: 16, color: white),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
