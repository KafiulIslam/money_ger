import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/models/expense_model.dart';
import 'package:money_ger/models/monthly_budget_model.dart';
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
  late int totalMonthlyExpense = 00;
  late List<MonthlyBudgetModel> monthlyBudgetList = [];

  /// for report ///

  late int family = 00;
  late int personal = 00;
  late int transport = 00;
  late int donation = 00;
  late int medicine = 00;
  late int other = 00;

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
        monthlyBudgetList.clear();
        notifyListeners();

        res.documents.forEach((e) {
          // monthlyBudgetList.add(MonthlyBudgetModel(
          //     monthId: e.$id ?? '',
          //     monthlyBudget: e.data['monthlyBudget'] ?? 00,
          //     createdAt: e.data['createdAt'] ?? DateTime.now(),
          //     monthName: e.data['monthName'] ?? '',
          //     userId: e.data['userID'] ?? ''));
          // notifyListeners();
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
          queries: [
            Query.limit(5000),
          ]);

      if (res.documents.isNotEmpty) {
        expenseList.clear();
        totalMonthlyExpense = 00;
        notifyListeners();

        res.documents.forEach((e) {
          if (e.data['userID'] == uid &&
              AppConstant.currentMonthId == e.data['monthlyBudgetId']) {
            /// there will be list ///
            expenseList.add(ExpenseModel(
                monthlyBudgetId: e.data['monthlyBudgetId'] ?? '',
                description: e.data['description'] ?? '',
                expenseType: e.data['expenseType'] ?? '',
                expenseAmount: e.data['expenseAmount'] ?? '',
                uid: e.data['userID'] ?? '',
                createdAt: e.data['createdAt'] ?? ''));
            totalMonthlyExpense =
                totalMonthlyExpense + e.data['expenseAmount'] as int;
            notifyListeners();


            /// for report ///

            if (e.data['expenseType'] == 'Food or Drinks' ||
                e.data['expenseType'] == 'Electricity Bill' ||
                e.data['expenseType'] == 'Cosmetics') {
              family = family + e.data['expenseAmount'] as int;
              notifyListeners();
            } else if (e.data['expenseType'] == 'Phone Bill' ||
                e.data['expenseType'] == 'Entertainment' ||
                e.data['expenseType'] == 'Sports' ||
                e.data['expenseType'] == 'Internet Bill') {
              personal = personal + e.data['expenseAmount'] as int;
              notifyListeners();
            } else if (e.data['expenseType'] == 'Transport' ||
                e.data['expenseType'] == 'Fuel Bill' ||
                e.data['expenseType'] == 'Travel') {
              transport = transport + e.data['expenseAmount'] as int;
              notifyListeners();
            } else if (e.data['expenseType'] == 'Donation' ||
                e.data['expenseType'] == 'Social Work') {
              donation = donation + e.data['expenseAmount'] as int;
              notifyListeners();
            } else if (e.data['expenseType'] == 'Doctor' ||
                e.data['expenseType'] == 'Medicine') {
              medicine = medicine + e.data['expenseAmount'] as int;
              notifyListeners();
            } else {
              other = other + e.data['expenseAmount'] as int;
            }
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
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isExpenseAdding = false;
      notifyListeners();
    }
  }
}
