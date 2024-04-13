import 'package:flutter/material.dart';
import 'package:money_ger/utils/typograpgy.dart';
import '../../../../../utils/color.dart';
import '../../../../../utils/spacer.dart';

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
      //leading: SvgPicture.asset(bagIcon),
      title: Text(
        widget.expenseType,
        style: tTextStyle700,
      ),
      children: [
       Text(widget.description)
      ],
    );
  }
}
