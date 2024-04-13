import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/models/expense_model.dart';
import 'package:money_ger/utils/constant/constant.dart';
import '../utils/app_storage.dart';
import '../utils/constant/appwrite_constant.dart';
import '../utils/custom_dialog.dart';
import '../utils/custom_snack.dart';

class MonthlyBudgetProvider extends ChangeNotifier {
  MonthlyBudgetProvider() {
    _init();
  }

  Client client = Client();
  late Databases db;

  _init() {
    client
        .setEndpoint(AppWriteConstant.endPoint)
        .setProject(AppWriteConstant.projectId);
    db = Databases(client);
    getMonthlyBudget();
    getExpenseList();
  }

  /// Monthly Budget ///

  late bool isBudgetLoading = false;
  late int monthlyBudget = 00;

  Future<void> getMonthlyBudget() async {
    try {
      isBudgetLoading = true;
      notifyListeners();

      final String? uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
        databaseId: AppWriteConstant.primaryDBId,
        collectionId: AppWriteConstant.monthlyBudgetCollectionId,
        // queries: [
        //   Query.equal("userID", uid)
        // ]
        // queries: [Query.equal("userID", '6619a55b3e79c45178a6')]
      );

      if (res.documents.isNotEmpty) {
        res.documents.forEach((e) {
          if (e.data['userID'] == uid && AppConstant.currentMonthId == e.$id) {
            monthlyBudget = e.data['monthlyBudget'] ?? 00;
            notifyListeners();
          }
        });
      } else {
        //CustomSnack.warningSnack('No task on your queue', context);
      }
    } catch (e) {
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isBudgetLoading = false;
      notifyListeners();
    }
  }

  /// add budget state ///

  late bool isMonthlyBudgetSetting = false;

  Future<void> setMonthlyBudget(int monthlyBudget, String createdAt,
      String monthName, BuildContext context) async {
    try {
      isMonthlyBudgetSetting = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.createDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.monthlyBudgetCollectionId,
          documentId: AppConstant.currentMonthId,
          data: {
            'monthlyBudget': monthlyBudget,
            'createdAt': createdAt,
            'monthName': monthName,
            'userID': uid
          }).then((value) {
        getMonthlyBudget();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Budget is set successfully!');
      });
      notifyListeners();
    } catch (e) {
      print('catch error ${e.toString()}');
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isMonthlyBudgetSetting = false;
      notifyListeners();
    }
  }

  Future<void> editMonthlyBudget(int monthlyBudget, String createdAt,
      String monthName, BuildContext context) async {
    try {
      isMonthlyBudgetSetting = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.updateDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.monthlyBudgetCollectionId,
          documentId: AppConstant.currentMonthId,
          data: {
            'monthlyBudget': monthlyBudget,
            'createdAt': createdAt,
            'monthName': monthName,
            'userID': uid
          }).then((value) {
        getMonthlyBudget();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Budget is updated successfully!');
      });
      notifyListeners();
    } catch (e) {
      print('catch error ${e.toString()}');
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isMonthlyBudgetSetting = false;
      notifyListeners();
    }
  }

  /// daily expense list ///

  late bool isExpenseListLoading = false;
  late List<ExpenseModel> expenseList = [];

  Future<void> getExpenseList() async {
    try {
      isExpenseListLoading = true;
      notifyListeners();

      final String? uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
        databaseId: AppWriteConstant.primaryDBId,
        collectionId: AppWriteConstant.expenseListCollectionId,
        // queries: [
        //   Query.equal("userID", uid)
        // ]
        // queries: [Query.equal("userID", '6619a55b3e79c45178a6')]
      );

      if (res.documents.isNotEmpty) {
        expenseList.clear();
        notifyListeners();

        res.documents.forEach((e) {
          if (e.data['userID'] == uid &&
              AppConstant.currentMonthId == e.data['monthlyBudgetId']) {

            /// there will be list ///
            expenseList.add(ExpenseModel(
                monthlyBudgetId: e.data['monthlyBudgetId'] ?? '',
                description:  e.data['description'] ?? '',
                expenseType:  e.data['expenseType'] ?? '',
                expenseAmount:  e.data['expenseAmount'] ?? '',
                uid:  e.data['userID'] ?? '',
                createdAt:  e.data['createdAt'] ?? ''));
            notifyListeners();
          }
        });
      } else {
        //CustomSnack.warningSnack('No task on your queue', context);
      }
    } catch (e) {
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isExpenseListLoading = false;
      notifyListeners();
    }
  }

  late bool isExpenseAdding = false;

  Future<void> addExpense(String monthlyBudgetId, String description,
      String expenseType, int expenseAmount, BuildContext context) async {
    try {
      isExpenseAdding = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      var res = await db.createDocument(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.expenseListCollectionId,
          documentId: ID.unique(),
          data: {
            'monthlyBudgetId': monthlyBudgetId,
            'description': description,
            'expenseType': expenseType,
            'expenseAmount': expenseAmount,
            'userID': uid,
            'createdAt': DateTime.now().toString()
          }).then((value) {
        getMonthlyBudget();
        getExpenseList();
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Expense is added successfully');
      });
      notifyListeners();
    } catch (e) {
      print('catch error ${e.toString()}');
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isExpenseAdding = false;
      notifyListeners();
    }
  }
}
