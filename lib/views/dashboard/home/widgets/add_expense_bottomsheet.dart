import 'package:flutter/material.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:money_ger/widgets/components/inputFields/common_textfield.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/custom_dialog.dart';
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
  final TextEditingController _expenseDate = TextEditingController();

  //expense date
  late DateTime? _selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primeColor,
              onPrimary: white,
              surface: white,
              onSurface: black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _expenseDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _expenseAmount.dispose();
    _description.dispose();
    _selectedExpenseType.dispose();
    _expenseDate.dispose();
    super.dispose();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<MonthlyBudgetProvider>(
                builder: (_, monthlyBudgetState, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(),
                  sixteenVerticalSpace,
                  _expenseType(),
                  eightVerticalSpace,
                  _buildExpenseDate(),
                  eightVerticalSpace,
                  CommonTextField(
                    fieldController: _description,
                    hintText: 'Enter expense description (Optional)',
                  ),
                  eightVerticalSpace,
                  _buildExpenseAmount(),
                  sixteenVerticalSpace,
                  PrimaryButton(
                    onTap: () {
                      if (_expenseAmount.text.isNotEmpty) {
                        monthlyBudgetState
                            .addExpense(
                                AppConstant.currentMonthId,
                                _description.text,
                                _selectedExpenseType.text,
                                _selectedDate.toString(),
                                int.parse(_expenseAmount.text),
                                context)
                            .then((value) {
                          Navigator.pop(context);
                          CustomDialog.autoDialog(context, Icons.check,
                              'Expense is added successfully');
                        });
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
        hintText: 'Type',
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

  Widget _buildExpenseDate() {
    return TextFormField(
      controller: _expenseDate,
      readOnly: true,
      onTap: () => _selectDate(),
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Expense Date',
        hintStyle: hintTextStyle,
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: iconColor,
          size: 22,
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
        hintText: 'Enter expense amount',
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
