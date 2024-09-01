import 'package:flutter/material.dart';
import 'package:money_ger/controllers/monthly_detail_controller.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../../../../models/expense_model.dart';
import '../../../../utils/color.dart';

class MonthlyDetail extends StatefulWidget {
  final String monthId;
  final List<ExpenseModel> expensesList;

  const MonthlyDetail(
      {Key? key,
      required this.monthId,
      required this.expensesList})
      : super(key: key);

  @override
  State<MonthlyDetail> createState() => _MonthlyDetailState();
}

class _MonthlyDetailState extends State<MonthlyDetail> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MonthlyDetailController>(builder: (_, detailState, child) {
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
          centerTitle: true,
          iconTheme: IconThemeData(color: white),
          title: Text(
            widget.monthId,
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await detailState.sharePdf(
                      widget.monthId, widget.expensesList);
                },
                icon: Icon(
                  Icons.share_outlined,
                  color: white,
                )),
            sixteenHorizontalSpace
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.expensesList.isEmpty
              ? const Center(child: Text('No available history'))
              : ListView.separated(
                  itemCount: widget.expensesList.length,
                  separatorBuilder: (_, index) => eightVerticalSpace,
                  itemBuilder: (context, index) {
                    var item = widget.expensesList[index];
                    return ListTile(
                      title: Text(item.description,
                          style: tTextStyle600.copyWith(
                              color: black, fontSize: 14)),
                      subtitle: Text(item.expenseType,
                          style: tTextStyleRegular.copyWith(
                              color: black, fontSize: 14)),
                      trailing: Text('$userCurrency ${item.expenseAmount.toString()}',
                          style: tTextStyle700.copyWith(
                              color: iconColor, fontSize: 14)),
                    );
                  },
                ),
        ),
      );
    });
  }
}
