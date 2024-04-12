import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/home/widgets/add_budget_bottomsheet.dart';
import '../../utils/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Text(
          'Monthly History',
          style: tTextStyleBold.copyWith(color: white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [_monthlyBudgetCard(context)],
        ),
      ),
    );
  }

  Widget _monthlyBudgetCard(BuildContext context) {
    final String currentMonth =
        DateFormat.MMMM().format(DateTime.now()).toString();
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
                  currentMonth,
                  style: tTextStyleBold.copyWith(fontSize: 18, color: white),
                ),
                Text(
                  '  /  Budget',
                  style: tTextStyle700.copyWith(fontSize: 16, color: white),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      CustomDialog.bottomSheet(context, const AddBudgetBottomSheet());
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
                  "Balance in $currentMonth",
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
