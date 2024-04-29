import 'package:flutter/material.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/spacer.dart';
import '../../../../utils/typograpgy.dart';

class DebtTile extends StatefulWidget {
  final String documentId;
  final String debtName;
  final String createdAt;
  final int amount;

  const DebtTile(
      {Key? key,
      required this.documentId,
      required this.debtName,
      required this.createdAt,
      required this.amount})
      : super(key: key);

  @override
  State<DebtTile> createState() => _DebtTileState();
}

class _DebtTileState extends State<DebtTile> {
  String getCreatedDate(date) {
    List<String> parts = date.split('T');
    String timeString = parts[0];
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebitCreditProvider>(builder: (_, debitCreditState, child) {
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      widget.debtName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          tTextStyleBold.copyWith(fontSize: 18, color: white),
                    ),
                  ),
                ),
                const Spacer(),
                 InkWell(
                        onTap: () {
                          debitCreditState.deleteDebts(
                              widget.documentId, context);
                        },
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
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: white,
                  ),
                  eightHorizontalSpace,
                  Text(
                    getCreatedDate(widget.createdAt),
                    style: tTextStyleBold.copyWith(fontSize: 14, color: white),
                  ),
                  const Spacer(),
                  Text(
                    "${widget.amount.toString()} TK",
                    style: tTextStyle700.copyWith(fontSize: 16, color: white),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
