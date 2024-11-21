import 'package:flutter/material.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/views/dashboard/debitCredit/widgets/add_debit_credit_bottom.dart';
import 'package:money_ger/views/dashboard/debitCredit/widgets/debt_tile.dart';
import 'package:money_ger/widgets/components/buttons/custom_add_icon.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/spacer.dart';
import '../../../utils/typograpgy.dart';

class DebitCreditScreen extends StatefulWidget {
  const DebitCreditScreen({Key? key}) : super(key: key);

  @override
  State<DebitCreditScreen> createState() => _DebitCreditScreenState();
}

class _DebitCreditScreenState extends State<DebitCreditScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DebitCreditProvider>(builder: (_, debitCreditState, child) {
      return DefaultTabController(
        length: 2,
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
              title: Text(
                'Debit Credit',
                style: tTextStyleBold.copyWith(color: textPrimaryColor, fontSize: 20),
              ),
              bottom: TabBar(
               // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                dividerColor: primaryLight,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: primeColor,
                indicatorWeight: 5,
                // indicator: UnderlineTabIndicator(
                //     borderSide: BorderSide(width: 5.0),
                //     insets: EdgeInsets.symmetric(horizontal:8.0)
                // ),
                labelStyle: tTextStyle700.copyWith(color: textPrimaryColor),
                unselectedLabelColor: iconColor,
                tabs: [
                  Tab(
                      child: Column(
                    children: [
                      const Text('Debtors'),
                      Text(debitCreditState.totalDebit.toString())
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      const Text('Creditors'),
                      Text(debitCreditState.totalCredit.toString())
                    ],
                  )),
                ],
              ),
              actions: [
                CustomAddIcon(onTap: (){
                  CustomDialog.dialogBuilder(
                      context, const AddDebitCreditBottomSheet());
                }),
                sixteenHorizontalSpace
              ],
            ),
            body: debitCreditState.isDebtListLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _debitors(),
                      _creditors(),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Widget _debitors() {
    final debitCreditState =
        Provider.of<DebitCreditProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: debitCreditState.debitList.isEmpty
          ? Center(
              child: Text(
                'You have no debtors',
                style: tTextStyle600.copyWith(color: black),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: debitCreditState.debitList.length,
              itemBuilder: (_, index) {
                var item = debitCreditState.debitList[index];
                return DebtTile(
                    documentId: item.id,
                    debtName: item.debtsName,
                    transactionType: item.debtsType,
                    createdAt: item.createdAt,
                    amount: item.debtsAmount);
              },
              separatorBuilder: (_, index) => sixteenVerticalSpace,
            ),
    );
  }

  Padding _creditors() {
    final debitCreditState =
        Provider.of<DebitCreditProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: debitCreditState.creditList.isEmpty
          ? Center(
              child: Text(
                'You have no creditors',
                style: tTextStyle600.copyWith(color: black),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: debitCreditState.creditList.length,
              itemBuilder: (_, index) {
                var item = debitCreditState.creditList[index];
                return DebtTile(
                    documentId: item.id,
                    debtName: item.debtsName,
                    transactionType: item.debtsType,
                    createdAt: item.createdAt,
                    amount: item.debtsAmount);
              },
              separatorBuilder: (_, index) => sixteenVerticalSpace,
            ),
    );
  }
}
