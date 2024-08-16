import 'package:flutter/material.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:money_ger/widgets/components/inputFields/common_textfield.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/spacer.dart';
import '../../../../utils/typograpgy.dart';

class AddDebitCreditBottomSheet extends StatefulWidget {
  const AddDebitCreditBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddDebitCreditBottomSheet> createState() =>
      _AddDebitCreditBottomSheetState();
}

class _AddDebitCreditBottomSheetState extends State<AddDebitCreditBottomSheet> {
  final TextEditingController _debtsAmount = TextEditingController();
  final TextEditingController _debtsName = TextEditingController();
  final TextEditingController _selectedDebtsType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24)),
            color: white),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<DebitCreditProvider>(
                builder: (_, debitCreditState, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(),
                  sixteenVerticalSpace,
                  _debtsType(),
                  sixteenVerticalSpace,
                  CommonTextField(
                    fieldController: _debtsName,
                    hintText: 'Enter your debitor\'s / creditor\'s name',
                  ),
                  sixteenVerticalSpace,
                  _buildDebtsAmount(),
                  sixteenVerticalSpace,
                  PrimaryButton(
                    onTap: () {
                      if (_debtsAmount.text.isNotEmpty) {
                        // debitCreditState.addExpense(
                        //     AppConstant.currentMonthId, _debtsName.text,
                        //     _selectedDebtsType.text, int.parse(_debtsAmount.text),
                        //     context);
                        debitCreditState.addDebts(_debtsName.text,
                            _selectedDebtsType.text, int.parse(_debtsAmount.text), context);
                      }
                    },
                    buttonTitle: 'Save',
                    isLoading: debitCreditState.isDebtsAdding,
                  ),
                  primaryVerticalSpace
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.clear,
              color: trans,
            )),
        Text(
          'Add Debit/Credit',
          style: tTextStyle500.copyWith(fontSize: 20, color: black),
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: iconColor,
            )),
      ],
    );
  }

  Widget _debtsType() {
    return TextFormField(
      controller: _selectedDebtsType,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Select transaction type',
        hintStyle: hintTextStyle,
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            enableFeedback: true,
            items: AppConstant.debtsTypeList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDebtsType.text = value!;
              });
            },
          ),
        ),
        focusedBorder: AppConstant.focusOutLineBorder,
        enabledBorder: AppConstant.enableOutLineBorder,
        errorBorder: AppConstant.outlineErrorBorder,
        focusedErrorBorder: AppConstant.outlineErrorBorder,
        focusColor: secondaryColor,
      ),
    );
  }

  Widget _buildDebtsAmount() {
    return TextFormField(
      controller: _debtsAmount,
      autofocus: false,
      cursorColor: primeColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Enter transaction amount',
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
