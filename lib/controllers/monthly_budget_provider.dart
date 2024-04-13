import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
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
    //getAllTaskList();
  }

  /// Monthly Budget ///

  late bool isBudgetLoading = false;
  late int monthlyBudget = 00;


  Future<void> getMonthlyBudget() async {
    try {
      isBudgetLoading = true;
      notifyListeners();

      final uid = await AppStorage.getUserId();

      final res = await db.listDocuments(
          databaseId: AppWriteConstant.primaryDBId,
          collectionId: AppWriteConstant.monthlyBudgetCollectionId,
          queries: [Query.equal("userId", uid)]);

      print('one0');
      if (res.documents.isNotEmpty) {

        print('two');
        res.documents.forEach((e) {

          print('alkdfjakld ${e.data['monthlyBudget']}');

          if (AppConstant.currentMonthId == e.$id) {
            monthlyBudget = e.data['monthlyBudget'] ?? 00;
            notifyListeners();
            print('tgree');
          }
        });
      } else {
        print('four');
        //CustomSnack.warningSnack('No task on your queue', context);
      }
    } catch (e) {
      print('five ${e.toString()}');
      // CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isBudgetLoading = false;
      notifyListeners();
    }
  }

  /// add task state ///

  late bool isMonthlyBudgetSetting = false;

  Future<void> setMonthlyBudget(int monthlyBudget, String createdAt, monthName,
      BuildContext context) async {
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
            'userId': uid
          }).then((value) {
        Navigator.pop(context);
        CustomDialog.autoDialog(
            context, Icons.check, 'Budget is set successfully!');
        // getTodayTaskList();
        // getAllTaskList();
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
}
