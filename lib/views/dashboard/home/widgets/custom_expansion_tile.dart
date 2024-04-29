import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import '../../../../../utils/color.dart';

class CartExpansionTile extends StatefulWidget {
  final String monthlyBudgetId;
  final String description;
  final String expenseType;
  final int expenseAmount;
  final String uid;
  final String createdAt;

  const CartExpansionTile({
    Key? key,
    required this.monthlyBudgetId,
    required this.description,
    required this.expenseType,
    required this.expenseAmount,
    required this.uid,
    required this.createdAt,
  }) : super(key: key);

  @override
  State<CartExpansionTile> createState() => _CartExpansionTileState();
}

class _CartExpansionTileState extends State<CartExpansionTile> {
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
      // leading: IconButton(onPressed: (){
      //   getDateDetails();
      // }, icon: Icon(Icons.add)),
      trailing: Text("${widget.expenseAmount.toString()} Tk",
        style: tTextStyleBold.copyWith(color: black, fontSize: 16),),
      title: Row(
        children: [
          Text(
            date, style: tTextStyleBold.copyWith(color: black, fontSize: 20),),
          sixteenHorizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateName,
                style: tTextStyle500.copyWith(color: black, fontSize: 14),),
              Text(widget.monthlyBudgetId,
                style: tTextStyle500.copyWith(color: black, fontSize: 16),),
            ],
          )
        ],
      ),
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(widget.expenseType,
              style: tTextStyleBold.copyWith(color: black, fontSize: 16),),
            const Spacer(),
            const SizedBox(height: 5, width: 5,),
          ],),
          Text(widget.description,
            style: tTextStyleRegular.copyWith(color: black, fontSize: 14),),
        ],)
      ],
    );
  }
}
