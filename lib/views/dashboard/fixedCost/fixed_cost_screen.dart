import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/fixed_cost_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/controllers/notification_services.dart';
import 'package:money_ger/utils/app_storage.dart';
import 'package:money_ger/utils/assets_path.dart';
import 'package:money_ger/utils/constant/constant.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:money_ger/views/dashboard/fixedCost/widgets/add_fixed_cost_bottom.dart';
import 'package:money_ger/views/dashboard/fixedCost/widgets/fixed_cost_tile.dart';
import 'package:money_ger/views/dashboard/home/widgets/add_budget_bottomsheet.dart';
import 'package:money_ger/views/dashboard/home/widgets/add_expense_bottomsheet.dart';
import 'package:money_ger/views/dashboard/home/widgets/custom_expansion_tile.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:money_ger/widgets/components/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../../main.dart';
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
      return Scaffold(
        backgroundColor: scaffoldColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: primeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'Fixed Cost',
                style: tTextStyleBold.copyWith(color: white, fontSize: 20),
              ),
              Text(
                fixedCostState.totalFixedCost.toString(),
                style: tTextStyle500.copyWith(color: white, fontSize: 16),
              )
            ],
          ),
        ),
        //body: Center(child: Text('Please create your monthly fixed cost list')),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primeColor,
          onPressed: () {
            fixedCostState.getFixedCostList();
            // CustomDialog.dialogBuilder(
            //     context, const AddFixedCostBottomSheet());
          },
          child: const Icon(
            Icons.add,
            color: white,
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
