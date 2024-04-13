import 'package:flutter/material.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/constant/constant.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/home/widgets/add_budget_bottomsheet.dart';
import 'package:provider/provider.dart';
import '../../utils/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Monthly History',
          style: tTextStyleBold.copyWith(color: white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<MonthlyBudgetProvider>(builder: (_, monthlyBudgetState, child){
          return Column(
            children: [_monthlyBudgetCard(context)],
          );
        }),
      ),
    );
  }

  Widget _monthlyBudgetCard(BuildContext context) {

    final monthlyBudgetState = Provider.of<MonthlyBudgetProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: primaryColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppConstant.currentMonth,
                  style: tTextStyleBold.copyWith(fontSize: 18, color: white),
                ),
                Text(
                  '  /  ${monthlyBudgetState.monthlyBudget.toString()}',
                  style: tTextStyle700.copyWith(fontSize: 16, color: white),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      monthlyBudgetState.getMonthlyBudget();
                      //CustomDialog.bottomSheet(context, const AddBudgetBottomSheet());
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      size: 32,
                      color: secondaryColor,
                    )),
              ],
            ),
            eightVerticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Balance in ${AppConstant.currentMonth}",
                  style: tTextStyleBold.copyWith(fontSize: 18, color: white),
                ),
                Text(
                  'Budget',
                  style: tTextStyle700.copyWith(fontSize: 16, color: white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
