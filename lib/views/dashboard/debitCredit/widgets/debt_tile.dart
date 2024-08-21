import 'package:flutter/material.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/widgets/components/dialog_hearder.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/spacer.dart';
import '../../../../utils/typograpgy.dart';
import '../../../../widgets/components/buttons/primary_button.dart';
import '../../../../widgets/components/inputFields/common_textfield.dart';

class DebtTile extends StatefulWidget {
  final String documentId;
  final String debtName;
  final transactionType;
  final String createdAt;
  final int amount;

  const DebtTile(
      {Key? key,
      required this.documentId,
      required this.debtName,
      required this.transactionType,
      required this.createdAt,
      required this.amount})
      : super(key: key);

  @override
  State<DebtTile> createState() => _DebtTileState();
}

class _DebtTileState extends State<DebtTile> {
  late TextEditingController _name;
  late TextEditingController _type;
  late TextEditingController _amount;

  String getCreatedDate(date) {
    List<String> parts = date.split('T');
    String timeString = parts[0];
    return timeString;
  }

  @override
  void initState() {
    _name = TextEditingController(text: widget.debtName);
    _amount = TextEditingController(text: widget.amount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebitCreditProvider>(builder: (_, debitCreditState, child) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: white,
          boxShadow: [
            BoxShadow(
              color: assColor.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
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
                      style: tTextStyle700.copyWith(fontSize: 18, color: black),
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  onSelected: (value) {
                    // your logic
                  },
                  iconColor: primeColor,
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: '',
                        onTap: () {
                          CustomDialog.dialogBuilder(context, _editDialog());
                        },
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: '/',
                        onTap: () {
                          debitCreditState.deleteDebts(
                              widget.documentId, context);
                        },
                      ),
                    ];
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: iconColor,
                  ),
                  eightHorizontalSpace,
                  Text(
                    getCreatedDate(widget.createdAt),
                    style: tTextStyle600.copyWith(fontSize: 14, color: black),
                  ),
                  const Spacer(),
                  Text(
                    "${widget.amount.toString()} TK",
                    style:
                        tTextStyle600.copyWith(fontSize: 16, color: iconColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _editDialog() {
    final debitCreditState =
        Provider.of<DebitCreditProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogHeader(title: 'Edit'),
        sixteenVerticalSpace,
        //_expenseType(),
        sixteenVerticalSpace,
        CommonTextField(
          fieldController: _name,
          hintText: 'Enter your expense description (Optional)',
        ),
        sixteenVerticalSpace,
        _buildExpenseAmount(),
        sixteenVerticalSpace,
        PrimaryButton(
          onTap: () async {
            await debitCreditState.updateDebitCredit(
                _name.text,
                widget.transactionType,
                int.parse(_amount.text),
                widget.documentId,
                context);
          },
          buttonTitle: 'Update',
          isLoading: debitCreditState.isDebitCreditUpdating,
        ),
        primaryVerticalSpace
      ],
    );
  }

  Widget _buildExpenseAmount() {
    return TextFormField(
      controller: _amount,
      autofocus: false,
      cursorColor: primeColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Edit transaction amount',
        hintStyle: hintTextStyle,
        focusedBorder: AppConstant.focusOutLineBorder,
        enabledBorder: AppConstant.enableOutLineBorder,
        errorBorder: AppConstant.outlineErrorBorder,
        focusedErrorBorder: AppConstant.outlineErrorBorder,
        focusColor: secondaryColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
