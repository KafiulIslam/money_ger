import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_ger/controllers/fixed_cost_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/utils/app_storage.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:money_ger/widgets/components/dialog_hearder.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/color.dart';
import '../../../../controllers/debit_credit_provider.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../widgets/components/buttons/primary_button.dart';
import '../../../../widgets/components/inputFields/common_textfield.dart';

class FixedCostTile extends StatefulWidget {
  final String docId;
  final String monthlyBudgetId;
  final String description;
  final String expenseType;
  final int expenseAmount;
  final String uid;
  final String createdAt;
  final bool isPaid;

  const FixedCostTile({
    Key? key,
    required this.docId,
    required this.monthlyBudgetId,
    required this.description,
    required this.expenseType,
    required this.expenseAmount,
    required this.uid,
    required this.createdAt,
    required this.isPaid,
  }) : super(key: key);

  @override
  State<FixedCostTile> createState() => _FixedCostTileState();
}

class _FixedCostTileState extends State<FixedCostTile> {
  late String dateName = '';
  late String date = '';
  late TextEditingController _description;
  late TextEditingController _expenseAmount;

  getDateDetails() {
    setState(() {
      date = DateFormat.d().format(DateTime.parse(widget.createdAt)).toString();
      dateName = DateFormat('EEEE').format(DateTime.parse(widget.createdAt));
    });
  }

  @override
  void initState() {
    getDateDetails();
    _description = TextEditingController(text: widget.description);
    _expenseAmount =
        TextEditingController(text: widget.expenseAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FixedCostProvider>(builder: (_, fixedCostState, child) {
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
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              widget.isPaid
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: widget.isPaid ? primeColor : iconColor,
            )),
        trailing: PopupMenuButton(
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
                    fixedCostState.deleteFixedCost(widget.docId, context);
                },
              ),
            ];
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.expenseType,
              style: tTextStyle500.copyWith(color: black, fontSize: 14),
            ),
            RichText(
              text: TextSpan(
                text: '$userCurrency ',
                style: tTextStyle600.copyWith(color: iconColor, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.expenseAmount.toString(),
                      style:
                          tTextStyle600.copyWith(color: black, fontSize: 16)),
                ],
              ),
            ),
            // Text(
            //   "$_currency ${widget.expenseAmount.toString()}",
            //   style: tTextStyle600.copyWith(color: black, fontSize: 16),
            // ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.expenseType,
                    style: tTextStyleBold.copyWith(color: black, fontSize: 16),
                  ),
                  const Spacer(),
                  const SizedBox(
                    height: 5,
                    width: 5,
                  ),
                ],
              ),
              Text(
                widget.description,
                style: tTextStyleRegular.copyWith(color: black, fontSize: 14),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _editDialog() {
    final fixedCostState =
        Provider.of<FixedCostProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogHeader(title: 'Edit'),
        sixteenVerticalSpace,
        CommonTextField(
          fieldController: _description,
          hintText: 'Enter fixed cost description',
        ),
        sixteenVerticalSpace,
        _buildExpenseAmount(),
        sixteenVerticalSpace,
        PrimaryButton(
          onTap: () {
            if (_description.text != widget.description ||
                _expenseAmount.text != widget.expenseAmount) {
              fixedCostState.updateFixedCostExpense(
                  widget.docId,
                  widget.monthlyBudgetId,
                  _description.text,
                  widget.expenseType,
                  int.parse(_expenseAmount.text),
                  widget.createdAt,
                  widget.isPaid,
                  context);
            } else {
              Navigator.pop(context);
            }
          },
          buttonTitle: 'Update',
          isLoading: fixedCostState.isFixedCostUpdating,
        ),
        primaryVerticalSpace
      ],
    );
  }

  Widget _buildExpenseAmount() {
    return TextFormField(
      controller: _expenseAmount,
      autofocus: false,
      cursorColor: primeColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Enter fixed cost amount',
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
