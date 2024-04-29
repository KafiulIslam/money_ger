import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_ger/models/expense_model.dart';
import 'package:money_ger/utils/typograpgy.dart';
import '../../../../../utils/color.dart';

class MonthlyHistoryExpansionTile extends StatefulWidget {
  final String monthlyBudgetId;
  final String description;
  final String expenseType;
  final int expenseAmount;
  final String uid;
  final String createdAt;
  final List<ExpenseModel> monthlyExpenseList;

  const MonthlyHistoryExpansionTile({
    Key? key,
    required this.monthlyBudgetId,
    required this.description,
    required this.expenseType,
    required this.expenseAmount,
    required this.uid,
    required this.createdAt,
    required this.monthlyExpenseList,
  }) : super(key: key);

  @override
  State<MonthlyHistoryExpansionTile> createState() => _MonthlyHistoryExpansionTileState();
}

class _MonthlyHistoryExpansionTileState extends State<MonthlyHistoryExpansionTile> {
  late String dateName = '';
  late String date = '';

  getDateDetails() {
    setState(() {
      date =
          DateFormat.d().format(DateTime.parse(widget.createdAt)).toString();
      dateName = DateFormat('EEEE').format(DateTime.parse(widget.createdAt));
    });
  }

  @override
  void initState() {
    getDateDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: white,
      backgroundColor: trans,
      collapsedTextColor: textColorBold,
      textColor: black,
      collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: borderColor)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: borderColor)),
      collapsedIconColor: black,
      iconColor: black,
      childrenPadding: const EdgeInsets.all(16.0),
      trailing: Text("${widget.expenseAmount.toString()} Tk",
        style: tTextStyleBold.copyWith(color: black, fontSize: 16),),
      title: Text(widget.monthlyBudgetId,
        style: tTextStyle500.copyWith(color: black, fontSize: 16),),
      children: [
        // ListView.separated(
        //   shrinkWrap: true,
        //   itemBuilder: (_, index) {
        //     var data =  widget.monthlyExpenseList[index];
        //     return ListTile(title: Text(data.monthlyBudgetId),);
        //   },
        //   separatorBuilder: (_, index) => sixteenVerticalSpace,
        //   itemCount: widget.monthlyExpenseList.length)
      ],
    );
  }
}
