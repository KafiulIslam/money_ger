import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/models/debit_credit_model.dart';
import 'package:money_ger/models/expense_model.dart';
import 'package:money_ger/models/monthly_budget_model.dart';
import 'package:money_ger/utils/constant/constant.dart';
import '../utils/app_storage.dart';
import '../utils/constant/appwrite_constant.dart';
import '../utils/custom_dialog.dart';
import '../utils/custom_snack.dart';

class DebitCreditProvider extends ChangeNotifier {
  DebitCreditProvider() {
    _init();
  }

  Client client = Client();
  late Databases db;

  _init() {
    client
        .setEndpoint(AppWriteConstant.endPoint)
        .setProject(AppWriteConstant.projectId);
    db = Databases(client);
    getDebtList();
  }

  /// debit credit get request ///

  late bool isDebtListLoading = false;
  late List<DebitCreditModel> debitList = [];
  late List<DebitCreditModel> creditList = [];
  late int totalDebit = 0;
  late int totalCredit = 0;

  Future<void> getDebtList() async {
    try {
      isDebtListLoading = true;
      notifyListeners();

      final String? uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.debitCreditCollectionId,
          queries: [
            Query.limit(5000),
          ]);

      if (res.documents.isNotEmpty) {
        debitList.clear();
        creditList.clear();
        totalDebit = 0;
        totalCredit = 0;
        notifyListeners();

        res.documents.forEach((e) {
          if (e.data['userID'] == uid) {
            if (e.data['debtsType'] == 'Debit') {
              debitList.add(DebitCreditModel(
                  id: e.$id ?? '',
                  userId: e.data['userID'] ?? '',
                  createdAt: e.data['createdAt'] ?? '',
                  debtsName: e.data['debtsName'] ?? '',
                  debtsType: e.data['debtsType'] ?? '',
                  debtsAmount: e.data['debtsAmount'] ?? 0));
              totalDebit = totalDebit + e.data['debtsAmount'] as int;
              notifyListeners();
            } else {
              creditList.add(DebitCreditModel(
                  id: e.$id ?? '',
                  userId: e.data['userID'] ?? '',
                  createdAt: e.data['createdAt'] ?? '',
                  debtsName: e.data['debtsName'] ?? '',
                  debtsType: e.data['debtsType'] ?? '',
                  debtsAmount: e.data['debtsAmount'] ?? 0));
              totalCredit = totalCredit + e.data['debtsAmount'] as int;
              notifyListeners();
            }
          }
        });
      } else {
        //CustomSnack.warningSnack('No task on your queue', context);
      }
    } catch (e) {
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isDebtListLoading = false;
      notifyListeners();
    }
  }

  /// debit credit add request ///

  late bool isDebtsAdding = false;

  Future<void> addDebts(String debtsName, String debtsType, int debtsAmount,
      BuildContext context) async {
    try {
      isDebtsAdding = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.createDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.debitCreditCollectionId,
          documentId: ID.unique(),
          data: {
            'userID': uid,
            'createdAt': DateTime.now().toString(),
            'debtsName': debtsName,
            'debtsType': debtsType,
            'debtsAmount': debtsAmount,
          }).then((value) {
        getDebtList();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Debt is added successfully');
      });

      notifyListeners();
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isDebtsAdding = false;
      notifyListeners();
    }
  }

  /// debit credit delete request ///

  late bool isDebtDeleting = false;

  Future<void> deleteDebts(String documentId, BuildContext context) async {
    try {
      isDebtDeleting = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db
          .deleteDocument(
              databaseId: AppWriteConstant.primaryDBId,
              collectionId: AppWriteConstant.debitCreditCollectionId,
              documentId: documentId)
          .then((value) {
        getDebtList();
      });
      //
      // var res = await db.createDocument(
      //     databaseId: AppWriteConstant.primaryDBId,
      //     collectionId: AppWriteConstant.debitCreditCollectionId,
      //     documentId: ID.unique(),
      //     data: {
      //       'userID': uid,
      //       'createdAt': DateTime.now().toString(),
      //       'debtsName': debtsName,
      //       'debtsType': debtsType,
      //       'debtsAmount': debtsAmount,
      //     }).then((value) {
      //   getDebtList();
      //   Navigator.pop(context);
      //   CustomDialog.autoDialog(
      //       context, Icons.check, 'Debt is added successfully');
      // });

      notifyListeners();
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isDebtDeleting = false;
      notifyListeners();
    }
  }
}
