import 'package:flutter/material.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant/constant.dart';
import '../../../../utils/spacer.dart';
import '../../../../utils/typograpgy.dart';

class AddBudgetBottomSheet extends StatefulWidget {
  const AddBudgetBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddBudgetBottomSheet> createState() => _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends State<AddBudgetBottomSheet> {
  late String selectedType = '';
  final TextEditingController _budgetController = TextEditingController();

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
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: assColor,
                      contentPadding: const EdgeInsets.all(12),
                      hintText: 'Enter your this month\'s budget',
                      hintStyle: hintTextStyle,
                      focusedBorder: AppConstant.focusOutLineBorder,
                      enabledBorder: AppConstant.enableOutLineBorder,
                      errorBorder: AppConstant.outlineErrorBorder,
                      focusedErrorBorder: AppConstant.outlineErrorBorder,
                      focusColor: secondaryColor,
                    ),
                  ),
                  sixteenVerticalSpace,
                  PrimaryButton(
                    onTap: () {
                      monthlyBudgetState.monthlyBudget == 00
                          ? monthlyBudgetState.setMonthlyBudget(
                              int.parse(_budgetController.text),
                              DateTime.now().toString(),
                              AppConstant.currentMonth,
                              context)
                          : monthlyBudgetState.editMonthlyBudget(
                              int.parse(_budgetController.text),
                              DateTime.now().toString(),
                              AppConstant.currentMonth,
                              context);
                    },
                    buttonTitle: 'Save',
                    isLoading: monthlyBudgetState.isMonthlyBudgetSetting,
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
          'Budget',
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
}
