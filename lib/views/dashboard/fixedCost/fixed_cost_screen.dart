import 'package:flutter/material.dart';
import 'package:money_ger/controllers/fixed_cost_provider.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/fixedCost/widgets/add_fixed_cost_bottom.dart';
import 'package:money_ger/views/dashboard/fixedCost/widgets/fixed_cost_tile.dart';
import 'package:money_ger/widgets/components/buttons/custom_add_icon.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';

class FixedCostScreen extends StatefulWidget {
  const FixedCostScreen({Key? key}) : super(key: key);

  @override
  State<FixedCostScreen> createState() => _FixedCostScreenState();
}

class _FixedCostScreenState extends State<FixedCostScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FixedCostProvider>(builder: (_, fixedCostState, child) {
      return SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: scaffoldColor,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: scaffoldColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Fixed Cost',
                    style: tTextStyleBold.copyWith(
                        color: textPrimaryColor, fontSize: 20),
                  ),
                  Text(
                    fixedCostState.totalFixedCost.toString(),
                    style: tTextStyle500.copyWith(color: iconColor, fontSize: 16),
                  )
                ],
              ),
              actions: [
                CustomAddIcon(onTap: (){
                  CustomDialog.dialogBuilder(
                      context, const AddFixedCostBottomSheet());
                }),
                sixteenHorizontalSpace
              ],
            ),
            body: _buildBody(),
          ),
        ),
      );
    });
  }

  Widget _buildBody() {
    final fixedCostState =
        Provider.of<FixedCostProvider>(context, listen: false);
    if (fixedCostState.isFixedListLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: primeColor,
      ));
    } else {
      if (fixedCostState.fixedCostList.isEmpty) {
        return Center(
            child: Text('Please create your monthly fixed cost list'));
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
              itemBuilder: (_, index) {
                var data = fixedCostState.fixedCostList[index];
                return FixedCostTile(
                  docId: data.docId,
                  monthlyBudgetId: data.monthlyBudgetId,
                  description: data.description,
                  expenseType: data.expenseType,
                  expenseAmount: data.expenseAmount,
                  uid: data.uid,
                  createdAt: data.createdAt,
                  isPaid: data.isPaid,
                );
              },
              separatorBuilder: (_, index) => sixteenVerticalSpace,
              itemCount: fixedCostState.fixedCostList.length),
        );
      }
    }
  }
}
