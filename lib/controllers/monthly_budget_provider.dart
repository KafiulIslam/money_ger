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
    getMonthlyHistory();
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
      );

      if (res.documents.isNotEmpty) {
        monthlyBudgetList.clear();
        notifyListeners();

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
        family = 00;
        personal = 00;
        transport = 00;
        donation = 00;
        medicine = 00;
        other = 00;
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

  /// add expense ///

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
        getMonthlyHistory();
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

  /// monthly history of expense ///

  late bool isMonthlyHistoryLoading = false;
  late Map<String, List<ExpenseModel>> expensesByMonth = {};
  late Map<String, int> totalExpensesByMonth = {};

  Future<void> getMonthlyHistory() async {
    try {
      isMonthlyHistoryLoading = true;
      notifyListeners();

      final String? uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.expenseListCollectionId,
          queries: [
            Query.limit(5000),
          ]);

      if (res.documents.isNotEmpty) {
        expensesByMonth.clear();
        totalExpensesByMonth.clear();
        notifyListeners();

        res.documents.forEach((e) {
          if (e.data['userID'] == uid) {
            String monthId = e.data['monthlyBudgetId'];

            if (!expensesByMonth.containsKey(monthId)) {
              expensesByMonth[monthId] = [];
              totalExpensesByMonth[monthId] = 0;
            }

            final expense = ExpenseModel(
              monthlyBudgetId: monthId,
              description: e.data['description'] ?? '',
              expenseType: e.data['expenseType'] ?? '',
              expenseAmount: e.data['expenseAmount'] as int,
              uid: e.data['userID'] ?? '',
              createdAt: e.data['createdAt'] ?? '',
            );

            expensesByMonth[monthId]!.add(expense);

            // Add to the total monthly expense for this monthId
            totalExpensesByMonth[monthId] = totalExpensesByMonth[monthId]! + (e.data['expenseAmount'] as int);

            // Calculate total monthly expense for the current month
            // if (AppConstant.currentMonthId == monthId) {
            //   totalMonthlyExpense += e.data['expenseAmount'] as int;
            // }
          }
        });

        // You can now convert the map to a list of lists if needed
        List<List<ExpenseModel>> groupedExpenseList =
            expensesByMonth.values.toList();
        notifyListeners();
      } else {
        // CustomSnack.warningSnack('No expenses found', context);
      }
    } catch (e) {
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isMonthlyHistoryLoading = false;
      notifyListeners();
    }
  }
}
