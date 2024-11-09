import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/models/expense_model.dart';
import 'package:money_ger/models/monthly_budget_model.dart';
import '../models/fixed_cost_model.dart';
import '../utils/app_storage.dart';
import '../utils/constant/appwrite_constant.dart';
import '../utils/constant/constant.dart';
import '../utils/custom_dialog.dart';
import '../utils/custom_snack.dart';

class FixedCostProvider extends ChangeNotifier {
  FixedCostProvider() {
    _init();
  }

  Client client = Client();
  late Databases db;

  _init() {
    client
        .setEndpoint(AppWriteConstant.endPoint)
        .setProject(AppWriteConstant.projectId);
    db = Databases(client);
    getFixedCostList();
  }

  /// Monthly Budget ///

  late bool isBudgetLoading = false;
  late int monthlyBudget = 00;

  /// fixed cost list ///

  late int totalFixedCost = 00;

  late bool isFixedListLoading = false;
  late List<FixedCostModel> fixedCostList = [];

  Future<void> getFixedCostList() async {
    try {
      isFixedListLoading = true;
      notifyListeners();

      final String? uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.fixedCostCollectionId,
          queries: [
            Query.limit(5000),
          ]);

      if (res.documents.isNotEmpty) {
        fixedCostList.clear();
        totalFixedCost = 0;
        notifyListeners();

        res.documents.forEach((e) {
          if (e.data['userID'] == uid) {
            /// there will be list ///

            fixedCostList.add(FixedCostModel(
                docId: e.$id,
                monthlyBudgetId: e.data['monthlyBudgetId'] ?? '',
                description: e.data['description'] ?? '',
                expenseType: e.data['expenseType'] ?? '',
                expenseAmount: e.data['expenseAmount'] ?? '',
                uid: e.data['userID'] ?? '',
                createdAt: e.data['createdAt'] ?? '',
                isPaid: e.data['isPaid'] ?? false));
            totalFixedCost = totalFixedCost + e.data['expenseAmount'] as int;
            notifyListeners();
          }
        });
      } else {
        //CustomSnack.warningSnack('No task on your queue', context);
      }
    } catch (e) {
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isFixedListLoading = false;
      notifyListeners();
    }
  }

  /// add expense ///

  late bool isFixedCostAdding = false;

  Future<void> addFixedCost(
      String monthlyBudgetId,
      String description,
      String expenseType,
      int expenseAmount,
      bool isPaid,
      BuildContext context) async {
    try {
      isFixedCostAdding = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.createDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.fixedCostCollectionId,
          documentId: ID.unique(),
          data: {
            'monthlyBudgetId': monthlyBudgetId,
            'description': description,
            'expenseType': expenseType,
            'expenseAmount': expenseAmount,
            'userID': uid,
            'createdAt': DateTime.now().toString(),
            'isPaid': isPaid
          }).then((value) {
        getFixedCostList();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Fixed cost is added successfully');
      });

      notifyListeners();
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isFixedCostAdding = false;
      notifyListeners();
    }
  }

  /// edit daily expense ///

  late bool isFixedCostUpdating = false;

  Future<void> updateFixedCostExpense(
      String docId,
      String monthlyBudgetId,
      String description,
      String expenseType,
      int expenseAmount,
      String createdAt,
      bool isPaid,
      BuildContext context) async {
    try {
      isFixedCostUpdating = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.updateDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.fixedCostCollectionId,
          documentId: docId,
          data: {
            'monthlyBudgetId': monthlyBudgetId,
            'description': description,
            'expenseType': expenseType,
            'expenseAmount': expenseAmount,
            'userID': uid,
            'createdAt': createdAt,
            'isPaid': isPaid
          }).then((value) {
        getFixedCostList();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Fixed Cost is updated successfully');
      });

      notifyListeners();
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isFixedCostUpdating = false;
      notifyListeners();
    }
  }

  /// delete daily expense ///

  late bool isFixedCostDeleting = false;

  Future<void> deleteFixedCost(
      String documentId, BuildContext context) async {
    try {
      isFixedCostDeleting = true;
      notifyListeners();

      var res = await db
          .deleteDocument(
              databaseId: AppWriteConstant.primaryDBId,
              collectionId: AppWriteConstant.fixedCostCollectionId,
              documentId: documentId)
          .then((value) {
        getFixedCostList();
        CustomDialog.autoDialog(
            context, Icons.check, 'Fixed cost is deleted successfully');
      });

      notifyListeners();
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isFixedCostDeleting = false;
      notifyListeners();
    }
  }
}
