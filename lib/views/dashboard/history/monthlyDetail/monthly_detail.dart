import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_ger/controllers/monthly_detail_controller.dart';
import 'package:money_ger/utils/assets_path.dart';
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
      {Key? key, required this.monthId, required this.expensesList})
      : super(key: key);

  @override
  State<MonthlyDetail> createState() => _MonthlyDetailState();
}

class _MonthlyDetailState extends State<MonthlyDetail> {

  String getDateDetails(String createdAt) {
    final String date =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(createdAt));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthlyDetailController>(builder: (_, detailState, child) {
      return Scaffold(
        backgroundColor: scaffoldColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: scaffoldColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: textPrimaryColor),
          title: Text(
            widget.monthId,
            style:
                tTextStyleBold.copyWith(color: textPrimaryColor, fontSize: 20),
          ),
          actions: [
            InkWell(
                onTap: () async {
                  await detailState.sharePdf(
                      widget.monthId, widget.expensesList);
                },
                child: Image.asset(
                  shareIcon,
                  height: 28,
                  width: 28,
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
                  separatorBuilder: (_, index) => sixteenVerticalSpace,
                  itemBuilder: (context, index) {
                    var item = widget.expensesList[index];
                    return _optionTile(
                        item.description,
                        item.expenseType,
                        getDateDetails(item.createdAt),
                        '$userCurrency ${item.expenseAmount.toString()}');
                  },
                ),
        ),
      );
    });
  }

  Widget _optionTile(
      String description, String type, String date, String amount) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description,
                    style: tTextStyle600.copyWith(color: black, fontSize: 14)),
                SizedBox(
                  height: 8,
                ),
                Text(date,
                    style:
                        tTextStyleRegular.copyWith(color: black, fontSize: 12)),
              ],
            ),
            Text(amount,
                style: tTextStyle700.copyWith(color: iconColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
