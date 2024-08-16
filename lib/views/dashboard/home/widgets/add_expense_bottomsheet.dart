import 'package:flutter/material.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:money_ger/widgets/components/inputFields/common_textfield.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/spacer.dart';
import '../../../../utils/typograpgy.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  const AddExpenseBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  final TextEditingController _expenseAmount = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _selectedExpenseType = TextEditingController();

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
            child: Consumer<MonthlyBudgetProvider>(
                builder: (_, monthlyBudgetState, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _header(),
                      sixteenVerticalSpace,
                      _expenseType(),
                      sixteenVerticalSpace,
                      CommonTextField(
                        fieldController: _description,
                        hintText: 'Enter your expense description (Optional)',
                      ),
                      sixteenVerticalSpace,
                      _buildExpenseAmount(),
                      sixteenVerticalSpace,
                      PrimaryButton(
                        onTap: () {
                          if (_expenseAmount.text.isNotEmpty) {
                            monthlyBudgetState.addExpense(
                                AppConstant.currentMonthId, _description.text,
                                _selectedExpenseType.text, int.parse(_expenseAmount.text),
                                context);
                          }
                        },
                        buttonTitle: 'Save',
                        isLoading: monthlyBudgetState.isExpenseAdding,
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
          'Add Expense',
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

  Widget _expenseType() {
    return TextFormField(
      controller: _selectedExpenseType,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Select your expense type',
        hintStyle: hintTextStyle,
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            enableFeedback: true,
            items: AppConstant.expenseTypeList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedExpenseType.text = value!;
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
        hintText: 'Enter your expense amount',
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
