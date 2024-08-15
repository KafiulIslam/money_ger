import 'package:flutter/material.dart';
import 'package:money_ger/controllers/debit_credit_provider.dart';
import 'package:money_ger/views/dashboard/debitCredit/widgets/add_debit_credit_bottom.dart';
import 'package:money_ger/views/dashboard/debitCredit/widgets/debt_tile.dart';
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
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: secondaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Debit Credit',
              style: tTextStyleBold.copyWith(color: white, fontSize: 20),
            ),
            bottom: TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: tTextStyle700.copyWith(color: white),
              unselectedLabelColor: iconColor,
              tabs: [
                Tab(child: Column(children: [
                  const Text('Debtors'),
                  Text(debitCreditState.totalDebit.toString())
                ],)),
                Tab(child: Column(children: [
                  const Text('Creditors'),
                  Text(debitCreditState.totalCredit.toString())
                ],)),
              ],
            ),
          ),
          body: debitCreditState.isDebtListLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _debitors(),
                    _creditors(),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondaryColor,
            onPressed: () {
              CustomDialog.bottomSheet(
                  context, const AddDebitCreditBottomSheet());
            },
            child: const Icon(
              Icons.add,
              color: white,
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
                'You have no debitors',
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
                    createdAt: item.createdAt,
                    amount: item.debtsAmount);
              },
              separatorBuilder: (_, index) => sixteenVerticalSpace,
            ),
    );
  }
}
